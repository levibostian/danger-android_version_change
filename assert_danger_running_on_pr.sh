if [[ -z "${CI_PULL_REQUESTS}" ]]; then
  echo -e "\033[31merror: Danger requires a pull request to function correctly\033[0m"
  exit 1
fi
