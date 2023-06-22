class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_user: current_user
    }
    result = MdBlogSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def current_user
    encoded_token = getBearerToken()
    if encoded_token
      payload = decodeSignedJwtToken(encoded_token).first
      user = User.where(provider: payload["provider"], uid: payload["uid"]).first
      return validateAccessToken(payload, user) ? user : nil
    end
    nil
  end

  def getBearerToken
    pattern = /^Bearer /
    request.authorization ? request.authorization.gsub(pattern, '') : nil
  end

  def decodeSignedJwtToken(token)
    JWT.decode(
      token,
      Rails.application.credentials.jwt_secret,
      true,
      { algorithm: 'HS256' }
    )
  end

  def validateAccessToken(payload, user)
    payload["access_token"] == user&.access_token && DateTime.now.utc.to_f < user.expiry.to_f
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
