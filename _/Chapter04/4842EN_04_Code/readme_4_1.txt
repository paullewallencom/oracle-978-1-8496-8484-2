Installation instructions for Database objects for Chapter 4
---------------------------------------------------------------

Create a local directory c:\packt\scripts\ch4 where the scripts are downloaded to

1. Open a WinSCP and Putty

2. Connect to the application tier on both

Putty
-----

3. Create a new directory on the application tier under $XXHR_TOP/install

	cd $XXHR_TOP/install

	mkdir ch4

4. Navigate to the new directory cd ch4

	cd ch4

WinSCP
------

5. FTP the files from c:\packt\scripts\ch4 to $XXHR_TOP/install/ch4


Putty
-----

6. Change the permissions of the script with the following command, 

	chmod 775 4842_04_01.sh

7. Run the following script to create all of the objects by issuing the following command 

	./4842_04_01.sh apps/<apps pwd>

WinSCP
------

8. Check the XXHR_4842_04_01.log file for errors.