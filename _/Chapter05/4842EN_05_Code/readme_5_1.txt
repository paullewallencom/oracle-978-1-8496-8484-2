Installation instructions for Database objects for Chapter 5
---------------------------------------------------------------

Create a local directory c:\packt\scripts\ch5 where the scripts are downloaded to

1. Open a WinSCP and Putty

2. Connect to the application tier on both

Putty
-----

3. Create a new directory on the application tier under $XXHR_TOP/install

	cd $XXHR_TOP/install

	mkdir ch5

4. Navigate to the new directory cd ch5

	cd ch5

WinSCP
------

5. FTP the files from c:\packt\scripts\ch5 to $XXHR_TOP/install/ch5


Putty
-----

6. Change the permissions of the script with the following command, 

	chmod 775 4842_05_01.sh

7. Run the following script to create all of the objects by issuing the following command 

	./4842_05_01.sh apps/<apps pwd>

WinSCP
------

8. Check the XXHR_4842_05_01.log file for errors.