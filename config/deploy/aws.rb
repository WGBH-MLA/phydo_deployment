raise ArgumentError, "Missing required environment variable, PHYDO_HOST." unless ENV['PHYDO_HOST']
raise ArgumentError, "Missing required environment variable, PHYDO_SSH_KEY." unless ENV['PHYDO_SSH_KEY']

server ENV['PHYDO_HOST'],
  user: 'ec2-user',
  roles: %w{web app db},
  ssh_options: {
    user: 'ec2-user',
    keys: [ENV['PHYDO_SSH_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
  }
