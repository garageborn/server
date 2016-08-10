FROM 845270614438.dkr.ecr.us-east-1.amazonaws.com/proxy:latest

COPY env /tmp/env
RUN cat /tmp/env | sed 's/^\(.*\)/export \1/g' > /tmp/environment.sh
RUN cat /tmp/environment.sh >> ~/.bashrc
RUN chmod +x /tmp/environment.sh
RUN . /tmp/environment.sh && echo $RAILS_ENV

CMD '. /tmp/environment.sh && bin/puma'
