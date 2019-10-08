FROM python:3.7

RUN useradd sam

WORKDIR /home/app

# get the requirements

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

# using gunicorn as my production server

RUN pip3 install gunicorn

# copy the application

COPY app app

COPY app.py boot.sh ./

RUN chmod +x boot.sh

ENV FLASK_APP app.py

# Set ownership and change user

RUN chown -R sam:sam ./

USER sam

# Run the app with port 5000 exposed on the container

EXPOSE 5000

ENTRYPOINT ["./boot.sh"]
