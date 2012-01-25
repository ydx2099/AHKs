#include FcnLib.ahk
assignGlobals()

;this is friggin awesome!!!!
RefreshLogin()
arrangeWindows()

listFees=Service of Process,Process Server Fees,Locate,Pinellas County Sticker
Loop, parse, listFees, CSV
{
   thisFee:=A_LoopField
   i:=A_Index
   thisFeeAmount:=FeeAmount%i%
   thisFeeType=Client
   if (i == 2)
      thisFeeType=Process Server
   AddFees(thisFeeType, thisFee, i)
}
GetFees()
ExitApp

AddFees(type, name, amount)
{
   OpenFeesWindow()
   ;ForceWinFocus("Status Pro", "RegEx")
   dist:=93
   ;WFCIImageSearch("images/firefly/fees/feesButton.bmp")
   ;Sleep, 5000
   WaitForImageSearch("images/firefly/fees/addNewFee.bmp", 60)
   ClickIfImageSearch("images/firefly/fees/addNewFee.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee2.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee3.bmp")
   ClickIfImageSearch("images/firefly/fees/addNewFee4.bmp")
   MouseMove, 5, 5, , R
   Click
   WFCIImageSearch("images/firefly/fees/feeGroupField.bmp")
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %type%

   ;Send, {TAB}
   Sleep, 1000
   WFCIImageSearch("images/firefly/fees/feeDescriptionField.bmp") ;this one is a little farther to the right

   ClickIfImageSearch("images/firefly/pinWindow.bmp")
   ;FIXME FIXME FIXME
   Sleep, 9000
   ClickIfImageSearch("images/firefly/fees/feesWindow.bmp")

   WFCIImageSearch("images/firefly/fees/feeDescriptionField.bmp") ;this one is a little farther to the right
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %name%
   Sleep, 4000
   WFCIImageSearch("images/firefly/fees/feeAmountField.bmp")
   MouseMove, %dist%, 5, , R
   Click
   Send, ^a
   Sleep, 1000
   Send, %amount%
   Sleep, 2000
   WFCIImageSearch("images/firefly/fees/save.bmp")
   Sleep, 2000
   WFCIImageSearch("images/firefly/fees/feesClose.bmp")
   Sleep, 5000
}

GetFees()
{
   OpenFeesWindow()
   WFCIImageSearch("images/firefly/fees/referenceNumber.bmp")
   Send, ^a
   rawFees:=CopyWait2()

   ;pull out the generic info
   RegExMatch(rawFees, "Reference \#  (\d+)", match)
   referenceNumber:=match1
   RegExMatch(rawFees, "(\d+) items in (\d+) pages", match)
   feesCount:=match1

   ;pull out the individual fees
   listFees=Service of Process,Process Server Fees,Locate,Pinellas County Sticker
   Loop, parse, listFees, CSV
   {
      thisFee:=A_LoopField
      i:=A_Index
      thisFeeAmount:=FeeAmount%i%
      thisFeeType=Client
      if (i == 2)
         thisFeeType=Process Server

      t=\t+
      needle=%thisFeeType%%t%%thisFee%%t%.\d+.\d+%t%\d+%t%.\d+.\d+%t%.(\d+\.\d+)
      RegExMatch(rawFees, needle, match)
      thisFeeAmount:=match1

      FeeAmount%i%:=thisFeeAmount
      FeeType%i%:=thisFeeType
      FeeName%i%:=thisFee
      if (thisFeeAmount != "")
         numberOfFeesCounted++
   }

   ;this probably isn't a big error, cause I wrote the stuff above to only account for some of the fees
   if (numberOfFeesCounted != feesCount)
   {
      errord("silent", "(error 31) fees counts did not match, might mean there are duplicate fees", referenceNumber, feesCount, numberOfFeesCounted)
      iniPP("(error 31) fees count mismatch")
   }

   errord("nolog", referenceNumber, feesCount, FeeAmount1, FeeAmount2, FeeAmount3, FeeAmount4)
   WFCIImageSearch("images/firefly/fees/feesClose.bmp")
}

OpenFeesWindow()
{
   ;ForceWinFocus("Status Pro", "RegEx")
   ArrangeWindows()
   FindTopOfFirefoxPage()

   ClickIfImageSearch("images/firefly/fees/feesClose.bmp")
   Sleep, 500
   if NOT ClickIfImageSearch("images/firefly/fees/feesButton.bmp")
   {
      ;click down on scrollbar
      Click(1753, 974, "control")
      Sleep, 500
      ClickIfImageSearch("images/firefly/fees/feesButton.bmp")
   }

   WaitForImageSearch("images/firefly/fees/referenceNumber.bmp")
   Sleep, 5000
   ;WFCIImageSearch("images/firefly/pinWindow.bmp")
   ClickIfImageSearch("images/firefly/pinWindow.bmp")
   ClickIfImageSearch("images/firefly/pinWindow2.bmp")
   ClickIfImageSearch("images/firefly/pinWindow.bmp")
   ClickIfImageSearch("images/firefly/pinWindow2.bmp")
   ClickIfImageSearch("images/firefly/pinWindow.bmp")
   ClickIfImageSearch("images/firefly/pinWindow2.bmp")
   WaitForImageSearch("images/firefly/fees/feesWindow.bmp")

}
;OpenFeesWindow()
;{
   ;Loop 3
   ;{
      ;ClickIfImageSearch("images/firefly/feesButton.bmp")
      ;ss()
   ;}
   ;WaitForImageSearch("images/firefly/feesWizardWindow.bmp")
;}


ExitApp
;;;;; USING THIS AS A LIB
#include fireflyButtons.ahk

/*

Reference #  2461358
Fee Group	Fee Description	Amount	Qty	Sales Tax	Total	Export Status	GP Import Date	Invoice #	Payee	Vendor Invoice	Override	PrePayment	PrePayment Check #
Add new record
1
Page size:
	select

    * 10
    * 20
    * 50

 1 items in 1 pages
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0


Reference #  2522980
Fee Group	Fee Description	Amount	Qty	Sales Tax	Total	Export Status	GP Import Date	Invoice #	Payee	Vendor Invoice	Override	PrePayment	PrePayment Check #
Add new record
1
Page size:
	select

    * 10
    * 20
    * 50

 4 items in 1 pages
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0
Client	Pinellas County Sticker	$3.00	1	$0.00	$3.00	New	 	0

*/

CopyWait2()
{
   Clipboard:=""
   ClipWait("")
   ss()
   copy()
   ;Send, {CTRLDOWN}c{CTRLUP}
   ss()
   ClipWaitNot("")

   returned:=Clipboard
   return returned
}

RefreshLogin()
{
   ;kill firefox
   CustomTitleMatchMode("Contains")
   while ProcessExist("firefox.exe")
   {
      WinClose, Mozilla Firefox
      Sleep, 100
   }

   ;start firefox again ; this method is a little difficult, imacros will be easier
   RunProgram("C:\Program Files\Mozilla Firefox\firefox.exe")
   panther:=SexPanther("melinda")
   melWorkEmail:=SexPanther("mel-work-email")
   imacro=
   (
   TAB CLOSEALLOTHERS
   URL GOTO=https://www.status-pro.biz/dashboard/Default.aspx
   TAG POS=1 TYPE=INPUT:TEXT FORM=NAME:form1 ATTR=ID:LoginUser_UserName CONTENT=AHmbaustian
   SET !ENCRYPTION NO
   TAG POS=1 TYPE=INPUT:PASSWORD FORM=NAME:form1 ATTR=ID:LoginUser_Password CONTENT=%panther%
   TAG POS=1 TYPE=INPUT:SUBMIT FORM=ID:form1 ATTR=ID:LoginUser_LoginButton
   TAG POS=1 TYPE=A ATTR=TXT:Click<SP>Here<SP>to<SP>Log<SP>Into<SP>FC
   )
   RunIMacro(imacro)
   WinWaitActive, %statusProMessage%
   if SimpleImageSearch("images/firefly/dialog/thereWasAnErrorHandlingYourCurrentAction.bmp")
      Click(170, 90, "control") ;center ok button
}
