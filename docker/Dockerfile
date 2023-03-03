FROM python:3.9

ADD slate slate
ADD static static
ADD templates templates
ADD markdown markdown
ADD requirements.txt requirements.txt

RUN pip install -r requirements.txt

EXPOSE 8080
CMD ["python", "-m", "slate", "--host=0.0.0.0"]
