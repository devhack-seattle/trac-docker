FROM python:latest

RUN apt-get update && apt-get install -y trac python-babel \
   python-pip && apt-get -y clean
RUN pip install --upgrade Babel Trac

ENV TRAC_PROJECT_NAME trac_project
ENV TRAC_DIR /var/local/trac
ENV TRAC_INI $TRAC_DIR/conf/trac.ini
ENV DB_LINK sqlite:db/trac.db
EXPOSE 8123

RUN mkdir -p $TRAC_DIR
RUN trac-admin $TRAC_DIR initenv $TRAC_PROJECT_NAME $DB_LINK
# RUN trac-admin $TRAC_DIR permission add $TRAC_ADMIN_NAME TRAC_ADMIN

RUN chown -R www-data: $TRAC_DIR
RUN chmod -R 775 $TRAC_DIR

USER www-data
CMD tracd -s --port 8123 $TRAC_DIR
