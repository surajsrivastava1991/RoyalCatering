table 50000 "Production Plan Header"
{
    DataClassification = CustomerContent;
    LookupPageId = "Production Plan Lists";
    DrillDownPageId = "Production Plan Lists";

    fields
    {
        field(1; "Production Plan No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Production Plan No." <> xRec."Production Plan No." then begin
                    SalesReceivableSetupG.Get();
                    NoSeriesMgtG.TestManual(SalesReceivableSetupG."Production Plan No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "BEO No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." where("kitchen Location" = field("Kitchen Location"), "Document Type" = filter('Order'));
            trigger OnValidate()
            var
                BEOL: Record "Sales Header";
            begin
                IF BEOL.Get(BEOL."Document Type"::Order, "BEO No.") then begin
                    "Project No." := BEOL."Shortcut Dimension 1 Code";
                    "Event Type" := BEOL."Type of Event";
                end eLSE begin
                    "Project No." := '';
                    "Event Type" := '';
                    "BEO Line No." := 0;
                end;
            end;
        }
        field(3; "BEO Line No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Line"."Line No." where("Document No." = field("BEO No."), "Document Type" = filter('Order'), "Production Line Created" = const(false));
            trigger OnValidate()
            var
                SaleLineL: record "Sales Line";
            begin
                SaleLineL.Reset();
                SaleLineL.SetRange("Document No.", "BEO No.");
                SaleLineL.SetRange("Line No.", "BEO Line No.");
                if SaleLineL.FindFirst() then begin
                    "No. of PAX" := SaleLineL.Quantity - SaleLineL."Quantity Shipped";
                    "Meal Description" := SaleLineL.Description;
                    "Event Type" := SaleLineL."Menu Type";
                end
                else begin
                    "No. of PAX" := 0;
                    "Meal Description" := '';
                    "Event Type" := '';
                end;
            end;
        }
        field(4; "Project No."; code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Kitchen Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location where("Location Type" = filter("Bulk kitchen"));
            Editable = true;
        }
        field(6; "Meal Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(8; "No. of PAX"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Status"; Option)
        {
            OptionMembers = "Open","Inprocess","Finished";
            OptionCaption = 'Open,Inprocess,Finished';
            DataClassification = CustomerContent;
        }
        field(10; "Recipe Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Production Plan Line"."Line Amount" where("Production Plan No." = field("Production Plan No.")));
            Editable = false;
        }
        field(11; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;

            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; "Event Type"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Event Type";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Production Plan No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        SalesReceivableSetupG.Get();
        if "Production Plan No." = '' then
            NoSeriesMgtG.InitSeries(SalesReceivableSetupG."Production Plan No.", xRec."No. Series", WorkDate(), "Production Plan No.", "No. Series");

    end;

    trigger OnModify()
    begin
        testfield(Status, Status::Open);
    end;

    trigger OnDelete()
    begin
        testfield(Status, Status::Open);
        ProductionPlanLineG.Reset();
        ProductionPlanLineG.SetRange("Production Plan No.", "Production Plan No.");
        ProductionPlanLineG.DeleteAll();
    end;

    trigger OnRename()
    begin

    end;

    procedure AssistEdit(OldPPHeaderP: Record "Production Plan Header"): Boolean
    var
        PPHeaderL: Record "Production Plan Header";
        SalesSetupL: Record "Sales & Receivables Setup";
    begin
        with OldPPHeaderP do begin
            Copy(Rec);
            SalesSetupL.Get();
            SalesSetupL.TestField("Production Plan No.");

            if NoSeriesMgtG.SelectSeries(SalesSetupL."Production Plan No.", OldPPHeaderP."No. Series", "No. Series") then begin
                NoSeriesMgtG.SetSeries("Production Plan No.");
                if PPHeaderL.Get("Production Plan No.") then
                    Error(Text051Lbl, 'boe no.', "Production Plan No.");
                Rec := OldPPHeaderP;
                exit(true);
            end;
        end;
    end;

    var
        ProductionPlanLineG: Record "Production Plan Line";
        SalesReceivableSetupG: Record "Sales & Receivables Setup";
        NoSeriesMgtG: Codeunit NoSeriesManagement;
        Text051Lbl: Label 'The sales %1 %2 already exists.';
}