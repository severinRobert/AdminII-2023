passdb {
  driver = passwd-file
  args = scheme=PLAIN username_format=%n /etc/dovecot/users
}