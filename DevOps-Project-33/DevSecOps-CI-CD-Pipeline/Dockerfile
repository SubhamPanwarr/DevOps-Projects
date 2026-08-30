FROM tomcat:9.0.121-jre21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/jpetstore.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
