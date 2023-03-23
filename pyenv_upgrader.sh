#/bin/bash

ENV_NAME=$(pyenv versions | sed -E 's#\* (.+) -->.*#\1#p;g;d;')
INSTALLED_VER=$(pyenv versions | grep -E '^\s+\d+\.\d+\.\d+$' | sed -E 's#  (.+)#\1#')
#AVAIL_VER=$(pyenv install -l | grep -E '^\s+\d+\.\d+\.\d+' | sed -E 's#  (.+)#\1#')

if [ -n "$ENV_NAME" ]; then
	echo ".... The current active environment to upgrade is $ENV_NAME"
	echo ".... The current python version is: $(python --version)"
	echo -e ".... Available installed python versions\n$INSTALLED_VER"
	read -p "++++ Enter a version (ex: 3.9.15): " ENTERED_VERSION
	echo ".... Creating module backup file requirements-to-upgrade.txt"
	pip freeze | cut -d"=" -f1 > requirements-to-upgrade.txt
	echo ".... Deleting environment $ENV_NAME"
	pyenv virtualenv-delete ${ENV_NAME}
	echo ".... Upgrading environment to $ENTERED_VERSION"
	pyenv virtualenv ${ENTERED_VERSION} ${ENV_NAME}
	echo ".... The new python version is: $(python --version)"
	echo ".... Reinstalling modules from requirements-to-upgrade.txt"
	pip install -r requirements-to-upgrade.txt
	echo ".... Don't forget to delete the requirements-to-upgrade.txt"
else
	echo "!!!!! There is not active environment to upgrade"
fi


#TODO
#1. Check whether the ENTERED_VERSION is valid and is in INSTALLED_VER
#2. Consider if adding functionality for installing ENTERED_VERSION that is not in INSTALLED_VER
