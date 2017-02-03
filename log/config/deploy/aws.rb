raise ArgumentError, "Missing required environment variable, AAPB_HOST." unless ENV['AAPB_HOST']
raise ArgumentError, "Missing required environment variable, AAPB_SSH_KEY." unless ENV['AAPB_SSH_KEY']

server ENV['AAPB_HOST'],
  user: 'ec2-user',
  roles: %w{web app db},
  ssh_options: {
    user: 'ec2-user',
    keys: [ENV['AAPB_SSH_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
  }
