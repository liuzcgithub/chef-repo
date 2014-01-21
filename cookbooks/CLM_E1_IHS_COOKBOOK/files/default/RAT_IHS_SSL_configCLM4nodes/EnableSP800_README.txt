This is the instruction to use scripts and couple manual steps to enable SP800-131 security feature

1.	Log on JTS WAS admin console to create a new keystore by creating a new Web Server Virtual Host (0.0.0.0:9443)
	Go to Servers > Web Servers > webserver0 > Web server virtual hosts > Click "New...".

        Select Security enabled virtual host and click Next.
	Keep all other defaults and enter a Key store password. Note: set to "ec11ipse".
	Enter IP Address 0.0.0.0.
	Enter Port 9443
	Click Next
	Click Finish

2.      Now delete the newly created Web Server Virtual Host (select the web server virtual host & click "Delete"). Be sure to propagate changes.
        Note: The existing Key Store settings on each app server should now use the new Keystore (not ihsserverkey.kdb)

3.	ssh <IHS hostname> as root
	> cd /tmp/RAT_IHS_SSL_config
	> sh BeforeEnableFIPS.sh
	Wait for the script complete and make sure no error

4.	Log on each WAS admin console to convert the certificate manually, should use IE browser which support TLSv1.2
	Security -> SSL certificate and key management , under Configuration settings, click Manage FIPS
	IMPORTANT: Make sure follow each step below, especially click "OK" or "SAVE" button. 

	Select "Enable SP800-131", "Strict" then click "OK"
	Ignore the error, click "Convert cerfiticates" on the right side of the page, click "OK", Don't click "Save".
 	click "OK" again, then click "Save"
	Now we turn off FIPS for retrieve signer certificate
	Click "Manage FIPS" again. Click "Disable FIPS", click "OK", click "Save"
	DO NOT RESTART WAS SERVER

5.	After completing step 4 for all application servers, ssh <IHS host again>
	cd /tmp/ RAT_IHS_SSL_config 
	sh enableFIPS.sh

6.	You should be ready to launch https://<IHS host>:9443/jts/setup	

