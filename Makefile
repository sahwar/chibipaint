CHIBI_IMAGES = gfx/images/icons.png gfx/images/smallicons.gif gfx/images/textures32.png
CHIBI_BIN = bin/chibipaint/*

JAVA_14_PATH = /System/Library/Frameworks/JavaVM.Framework/Versions/1.4

all: splash.jar chibi.jar cpcombined.jar test.jar

test.jar: test.out.jar
	java -jar "retrotranslator/retrotranslator-transformer-1.2.9.jar" -srcjar test.out.jar -destjar test.jar -classpath "${JAVA_14_PATH}/Classes/classes.jar:${JAVA_14_PATH}/Classes/jce.jar:${JAVA_14_PATH}/Classes/jsse.jar" 

splash.jar: splash.out.jar
	java -jar "retrotranslator/retrotranslator-transformer-1.2.9.jar" -srcjar splash.out.jar -destjar splash.jar -classpath "${JAVA_14_PATH}/Classes/classes.jar:${JAVA_14_PATH}/Classes/jce.jar:${JAVA_14_PATH}/Classes/jsse.jar:/System/Library/Java/Support/Deploy.bundle/Contents/Resources/Java/javaws.jar:bootstrap.jar" 

chibi.jar: chibi.out.jar
	java -jar "retrotranslator/retrotranslator-transformer-1.2.9.jar" -srcjar chibi.out.jar -destjar chibi.jar -classpath "${JAVA_14_PATH}/Classes/classes.jar:${JAVA_14_PATH}/Classes/jce.jar:${JAVA_14_PATH}/Classes/jsse.jar:/System/Library/Java/Support/Deploy.bundle/Contents/Resources/Java/javaws.jar:bootstrap.jar" 

# Fallback applet JAR which doesn't use JNLP launch:
cpcombined.jar: cpcombined.out.jar
	java -jar "retrotranslator/retrotranslator-transformer-1.2.9.jar" -srcjar cpcombined.out.jar -destjar cpcombined.jar -classpath "${JAVA_14_PATH}/Classes/classes.jar:${JAVA_14_PATH}/Classes/jce.jar:${JAVA_14_PATH}/Classes/jsse.jar" 

test.out.jar: bin/test/*
	jar -cf test.in.jar -C bin/ test/
	java -jar proguard/lib/proguard.jar @ test.pro -verbose

splash.out.jar: bootstrap.jar bin/splash/*
	jar -cf splash.in.jar -C bin/ splash/
	java -jar proguard/lib/proguard.jar @ splash.pro -verbose
	
chibi.out.jar: bootstrap.jar ${CHIBI_IMAGES} ${CHIBI_BIN}
	jar -cf chibi.in.jar -C bin/ chibipaint/
	jar -uf chibi.in.jar -C bin/ images/
	java -jar proguard/lib/proguard.jar @ chibi.pro -verbose

cpcombined.out.jar: ${CHIBI_IMAGES} ${CHIBI_BIN}
	jar -cf cpcombined.in.jar -C bin/ chibipaint/
	jar -uf cpcombined.in.jar -C bin/ images/
	jar -uf cpcombined.in.jar -C bin/ splash/
	jar -uf cpcombined.in.jar -C bin/ bootstrap/
	jar -uf cpcombined.in.jar -C bin/ javax/
	java -jar proguard/lib/proguard.jar @ chibipaint.pro -verbose

bootstrap.jar: bin/bootstrap/*
	jar -cf bootstrap.jar -C bin/ bootstrap/

clean:
	rm -f splash.jar
	rm -f splash.in.jar
	rm -f splash.out.jar
	rm -f chibi.jar
	rm -f chibi.in.jar
	rm -f chibi.out.jar
	rm -f test.jar
	rm -f test.in.jar
	rm -f test.out.jar
	rm -f cpcombined.jar
	rm -f cpcombined.in.jar
	rm -f cpcombined.out.jar
	rm -f chibi.jar.pack.gz
	rm -f splash.jar.pack.gz
	rm -f cpcombined.jar.pack.gz

%.jar.pack.gz : %.jar
	pack200 -E9 $@ $<
	
install: chibi.jar chibi.jar.pack.gz splash.jar splash.jar.pack.gz cpcombined.jar cpcombined.jar.pack.gz
	cp chibi.jar ../trunk/public_html/oekaki/chibi/
	cp splash.jar ../trunk/public_html/oekaki/chibi/
	cp cpcombined.jar ../trunk/public_html/oekaki/chibi/	
	cp test.jar ../trunk/public_html/oekaki/chibi/	
	cp chibi.jar.pack.gz ../trunk/public_html/oekaki/chibi/
	cp splash.jar.pack.gz ../trunk/public_html/oekaki/chibi/
	cp cpcombined.jar.pack.gz ../trunk/public_html/oekaki/chibi/
