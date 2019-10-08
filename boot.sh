#!/bin/sh
# simple shell script serves the flask app using gunicorn
exec gunicorn -b :5000 --access-logfile - --error-logfile - app:app
