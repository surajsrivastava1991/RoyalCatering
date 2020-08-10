tableextension 50051 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Salutation"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Salutation';

        }
        field(50001; "Body Line1"; Text[2000])
        {
            DataClassification = CustomerContent;
            Caption = 'Body Line1';

        }
        field(50002; "Body Line2"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Body Line2';
        }
        field(50003; "Thanking"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Thanking';

        }
        field(50004; "Person Singnature"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Person Singnature';
        }
        field(50014; "Signature (Company Name)"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Signature (Company Name)';
        }
        field(50015; "Singnature 1"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50016; "Singnature 2"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Singnature 3"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50005; "Created By"; Text[200])
        {
            TableRelation = "User Setup";
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(50006; "Mail Sent"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50007; "Ref. Requisition ID"; RecordId)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; "Requisition Reference"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        /*
        field(50008; "Quote Cancelled"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        */
        field(50008; "Quotation Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Quotation Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Cancelled';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled;
        }
        field(50010; "Last date for Quote Submission"; Date)
        {
            DataClassification = CustomerContent;
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            begin
                "Quotation Status" := Status;
            end;
        }
    }
    trigger OnInsert()
    begin
        PurchasePayableSetupG.GET();
        Salutation := PurchasePayableSetupG.Salutation;
        "Body Line1" := PurchasePayableSetupG."Body Line1";
        "Body Line2" := PurchasePayableSetupG."Body Line2";
        Thanking := PurchasePayableSetupG.Thanking;
        "Person Singnature" := PurchasePayableSetupG."Person Singnature";
        "Signature (Company Name)" := PurchasePayableSetupG."Signature (Company Name)";
        "Singnature 1" := PurchasePayableSetupG."Singnature 1";
        "Singnature 2" := PurchasePayableSetupG."Singnature 2";
        "Singnature 3" := PurchasePayableSetupG."Singnature 3";
        "Created By" := USERID();
    end;

    procedure SendMail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        VendorL: Record Vendor;
        UserSetupL: Record "User Setup";
        LocationL: Record Location;
        CompanyInfoL: Record "Company Information";
        PurchPaySetupL: Record "Purchases & Payables Setup";
        SMTPMailL: Codeunit "SMTP Mail";
        TempBlob: Codeunit "Temp Blob";
        OutputStream: OutStream;
        InputStream: InStream;
        SmtpConfigErr: Label 'SMTP setup is missing.';
        EmailToL: List of [Text];
        RecRef: RecordRef;

    begin
        if not SmtpMailL.IsEnabled() then
            Error(SmtpConfigErr);
        //
        CompanyInfoL.Get();
        PurchPaySetupL.Get();
        URL := GETURL(ClientType::SOAP, CompanyInfoL.Name, ObjectType::Page, 50, Rec);
        TempBlob.CreateOutStream(OutputStream);

        RecRef.GetTable(Rec);
        RecRef.SetRecFilter();
        Report.SaveAs(Report::"Purchase Order Details", '',
            ReportFormat::Pdf, OutputStream, RecRef);

        TempBlob.CreateInStream(InputStream);


        //
        SMTPMailSetup.GET();
        //Email to vendor
        VendorL.get("Buy-from Vendor No.");
        if VendorL."E-Mail" <> '' then
            EmailToL.add(VendorL."E-Mail")
        else
            Error('Vendor Email ID should not be blank');

        //Email to user
        if "Created By" <> '' then begin
            UserSetupL.Get("Created By");
            if UserSetupL."E-Mail" <> '' then
                EmailToL.Add(UserSetupL."E-Mail");
        end;
        //Email to location
        LocationL.get("Location Code");
        if LocationL."Warehouse/Store Incharge Email" <> '' then
            EmailToL.Add(LocationL."Warehouse/Store Incharge Email");
        SMTPMailL.Initialize();
        SMTPMailL.AddFrom(SMTPMailSetup."Send As", SMTPMailSetup."User ID");
        SMTPMailL.AddRecipients(EmailToL);
        SMTPMailL.AddSubject('Company Name :' + CompanyInfoL.Name + ', Purchase Order: ' + "No." + ' PO Date: ' + Format("Order Date"));
        SMTPMailL.AddBody(Salutation + ' ' + "Buy-from Contact" + ',');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<P>' + "Body Line1" + '</P>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<P>' + "Body Line2" + '</P>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody(Thanking);
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<B>' + "Person Singnature" + '</B>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<B><P style="font-size:12px">' + "Signature (Company Name)" + '</P></B>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<i>' + "Singnature 1" + '</1>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<i>' + "Singnature 2" + '</1>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<i>' + "Singnature 3" + '</1>');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AppendBody('<img src="./res/123321.jpg" alt="Royal Catering" height="100" width="350">');
        SMTPMailL.AppendBody('<Br>');
        SMTPMailL.AddTextBody(url);
        SMTPMailL.AddAttachmentStream(InputStream, "No." + '.pdf');
        if not SmtpMailL.Send() then
            Error(SmtpMailL.GetLastSendMailErrorText())
        else
            "Mail Sent" := true;

        Modify();
    end;

    var
        PurchasePayableSetupG: Record "Purchases & Payables Setup";
        URL: Text[1000];


}