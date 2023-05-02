passdb {
  driver = pam
  args = scheme=PLAIN username_format=%n /etc/dovecot/users
}