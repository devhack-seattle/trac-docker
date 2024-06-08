FROM python:latest

# ENV TRAC_INSTALL_URL "svn+https://svn.edgewall.org/repos/trac/branches/1.6-stable"
# ENV TRAC_INSTALL_URL=https://download.edgewall.org/trac/Trac-${VERSION}-py3-none-any.whl
ARG TRAC_INSTALL_URL
ARG TRAC_INSTALL_OPTS=babel,rest,pygments,textile,mysql,psycopg2-binary
RUN pip install "Trac[$TRAC_INSTALL_OPTS] ${TRAC_INSTALL_URL:+ @ $TRAC_INSTALL_URL}"

ARG TRAC_PROJECT_NAME=trac_project
ARG TRAC_DIR=/var/local/trac
ARG TRAC_INI=${TRAC_DIR}/conf/trac.ini
ARG DB_LINK=sqlite:db/trac.db

RUN echo ${TRAC_INSTALL_OPTS}
RUN mkdir -p ${TRAC_DIR}
WORKDIR ${TRAC_DIR}

RUN trac-admin . initenv ${TRAC_PROJECT_NAME} ${DB_LINK}
# RUN trac-admin . permission add $TRAC_ADMIN_NAME TRAC_ADMIN

RUN chown -R www-data: .
RUN chmod -R 775 .

EXPOSE 8000
USER www-data
ENTRYPOINT ["tracd", "--single-env", "."]
