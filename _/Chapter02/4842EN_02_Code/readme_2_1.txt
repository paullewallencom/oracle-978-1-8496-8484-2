Installation instructions for Database objects for Chapter 2
---------------------------------------------------------------

Create a local directory c:\packt\scripts\ch2 where the scripts are downloaded to

1. Open a WinSCP and Putty

2. Connect to the application tier on both

Putty
-----

3. Create a new directory on the application tier under $XXHR_TOP/install

	cd $XXHR_TOP/install

	mkdir ch2

4. Navigate to the new directory cd ch3

	cd ch2

WinSCP
------

5. FTP the files from c:\packt\scripts\ch2 to $XXHR_TOP/install/ch2


Putty
-----

6. Change the permissions of the script with the following command 

	chmod 775 4842_02_01.sh

7. Run the following script to create all of the objects by issuing the following command 

	./4842_02_01.sh apps/apps

WinSCP
------

8. Check the XXHR_4842_02_01.log file for errors.