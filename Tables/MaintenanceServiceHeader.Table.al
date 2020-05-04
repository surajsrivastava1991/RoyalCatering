table 50072 "Maintenance Service Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "MRO No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "MRO No." <> xRec."MRO No." then begin
                    SalesReceivableSetupG.Get();
                    NoSeriesMgtG.TestManual(SalesReceivableSetupG."Maintenance Service No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Asset ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Fixed Asset";
            trigger OnValidate()
            var
                FixedAssetL: Record "Fixed Asset";
                LocationL: Record Location;
            begin
                if FixedAssetL.Get("Asset ID") then begin
                    "Asset Description" := FixedAssetL.Description;
                    Equipment := FixedAssetL.Description;
                    if LocationL.Get(FixedAssetL."FA Location Code") then
                        "Location Name" := LocationL.Name
                    else
                        "Location Name" := '';
                end else begin
                    "Asset Description" := '';
                    Equipment := '';
                    "Location Name" := '';
                end;
            end;
        }
        field(3; "Asset Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Duration From"; Date)
        {
            DataClassification
            = CustomerContent;
            trigger OnValidate()
            begin
                if "Duration From" <> 0D then
                    if "Duration To" <> 0D then
                        "Break Duration" := "Duration To" - "Duration From" + 1;


            end;
        }
        field(5; "Duration To"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Duration From");
                if "Duration From" > "Duration To" then
                    Error('"Duration From Date" should be less than "Durantion To Date"');
                Validate("Duration From");
            end;
        }
        field(6; "Equipment"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Location Name"; text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Break Duration"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(9; "Details"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Consequnces"; Option)
        {
            OptionMembers = Major,Minor,Moderate;
            OptionCaption = 'Major,Minor,Moderate';
            Caption = 'Consequnces';
        }
        field(11; "Correction Action Plan"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Preventive action plan"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(13; "ManPower Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(14; "LPO No."; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Status"; Option)
        {
            OptionMembers = "Open","In-Process","Hold",Closed;
            OptionCaption = 'Open,In-Process,Hold,Closed';
            Caption = 'Status';
        }
        field(16; "Remarks"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(17; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "MRO No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        SalesReceivableSetupG.Get();
        if "MRO No." = '' then
            NoSeriesMgtG.InitSeries(SalesReceivableSetupG."Maintenance Service No.", xRec."No. Series", WorkDate(), "MRO No.", "No. Series");

    end;

    procedure AssistEdit(OldMSHeaderP: Record "Maintenance Service Header"): Boolean
    var
        PPHeaderL: Record "Production Plan Header";
        SalesSetupL: Record "Sales & Receivables Setup";
    begin
        with OldMSHeaderP do begin
            Copy(Rec);
            SalesSetupL.Get();
            SalesSetupL.TestField("Maintenance Service No.");

            if NoSeriesMgtG.SelectSeries(SalesSetupL."Maintenance Service No.", OldMSHeaderP."No. Series", "No. Series") then begin
                NoSeriesMgtG.SetSeries("MRO No.");
                if PPHeaderL.Get("MRO No.") then
                    Error(Text051Lbl, 'MRO No.', "MRO No.");
                Rec := OldMSHeaderP;
                exit(true);
            end;
        end;
    end;

    trigger OnModify()
    begin
        MaintenanceServiceLineG.Reset();
        MaintenanceServiceLineG.SetRange("MRO No.", "MRO No.");
        MaintenanceServiceLineG.SetRange(Posted, true);
        if not (MaintenanceServiceLineG.IsEmpty()) then
            Error('You cannot modify the document because few lines has been posted');
    end;

    trigger OnDelete()
    begin
        MaintenanceServiceLineG.Reset();
        MaintenanceServiceLineG.SetRange("MRO No.", "MRO No.");
        MaintenanceServiceLineG.SetRange(Posted, true);
        if not (MaintenanceServiceLineG.IsEmpty()) then
            Error('You cannot delete the document because few lines has been posted');
    end;

    var
        SalesReceivableSetupG: Record "Sales & Receivables Setup";
        MaintenanceServiceLineG: Record "Maintenance Service Line";

        NoSeriesMgtG: Codeunit NoSeriesManagement;
        Text051Lbl: Label 'The sales %1 %2 already exists.';
}