FROM python:latest

# ENV TRAC_INSTALL_URL "svn+https://svn.edgewall.org/repos/trac/branches/1.6-stable"
# ENV TRAC_INSTALL_URL=https://download.edgewall.org/trac/Trac-${VERSION}-py3-none-any.whl
ENV TRAC_INSTALL_OPTS babel,rest,pygments,textile,mysql,psycopg2-binary
RUN pip install "Trac[$TRAC_INSTALL_OPTS] ${TRAC_INSTALL_URL:+ @ $TRAC_INSTALL_URL}"

ENV TRAC_PROJECT_NAME trac_project
ENV TRAC_DIR /var/local/trac
ENV TRAC_INI $TRAC_DIR/conf/trac.ini
ENV DB_LINK sqlite:db/trac.db

RUN mkdir -p $TRAC_DIR
WORKDIR $TRAC_DIR

RUN trac-admin . initenv $TRAC_PROJECT_NAME $DB_LINK
# RUN trac-admin . permission add $TRAC_ADMIN_NAME TRAC_ADMIN

RUN chown -R www-data: .
RUN chmod -R 775 .

EXPOSE 8000
USER www-data
CMD tracd -s --port 8000 $TRAC_DIR
