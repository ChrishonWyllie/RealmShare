# RealmShare

RealmShare is a demo app for showing how to share RealmSwift objects between two devices running the same app. 

If you'd like a detailed explanation of building your own offline sharing app, take a look at my <a href="https://medium.com/@chrishonwyllie/sharing-realm-data-between-devices-in-ios-13-7eb2e53bcf53">Medium</a> post

## Sharing data

<br />
<div id="images">
    <p align="center">
    <img style="display: inline; margin: 0 5px;" src="images/export_img_1.png" width=150 height=300 />
    <img style="display: inline; margin: 0 5px;" src="images/import_img_1.png" width=450 height=300 />
</p>
</div>

Sharing data can be done using the typical `UIActivityViewController`. In this example, data can be airdropped to another
device, and if the other device has this app downloaded, it will automatically open and prompt you to update local records
with the imported data.


However, you may email the data as well in the form of a `.usrl` or `.ucsv` file, which stands for User List and User CSV respectively.
The UCSV file generates a csv-formatted file which may be useful in other places, although this was a bonus. 
