tableextension 50051 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Mail Body1"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50001; "Mail Body2"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50002; "Mail Body3"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50003; "Mail Body4"; Text[100])
        {
            DataClassification = CustomerContent;

        }
        field(50004; "Mail Body5"; Text[100])
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
    }
    trigger OnInsert()
    begin
        PurchasePayableSetupG.GET();
        "Mail Body1" := PurchasePayableSetupG."Mail Body1";
        "Mail Body2" := PurchasePayableSetupG."Mail Body2";
        "Mail Body3" := PurchasePayableSetupG."Mail Body3";
        "Mail Body4" := PurchasePayableSetupG."Mail Body4";
        "Mail Body5" := PurchasePayableSetupG."Mail Body5";
        "Created By" := USERID();
    end;

    procedure SendMail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        VendorL: Record Vendor;
        UserSetupL: Record "User Setup";
        LocationL: Record Location;
        CompanyInfoL: Record "Company Information";
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
        URL := System.GETURL(ClientType::SOAP, CompanyInfoL.Name, ObjectType::Page, 50, Rec);
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
        SMTPMailL.AddSubject('Company Name :' + CompanyInfoL.Name + ', Purchase Order: ' + "No.");
        SMTPMailL.AddBody("Mail Body1" + "Mail Body2" + "Mail Body3" + "Mail Body4" + "Mail Body5");
        SMTPMailL.AddBody('<Br>');
        SMTPMailL.AddBody(URL);
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