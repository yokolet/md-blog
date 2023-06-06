### How this app is developed

#### Create a Rails app

- command
```bash
% rails new md-blog --rc=./.railsrc-blog
```
- .railsrc-blog
```bash
--skip-action-mailer
--skip-action-mailbox
--skip-action-cable
--skip-action-text
--skip-active-job
--skip-active-storage
-d postgresql
-j esbuild
-c tailwind
-T
```

