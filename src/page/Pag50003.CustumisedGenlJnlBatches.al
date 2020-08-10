page 50003 "Custumised Genl Jnl. Batches"
{
    Caption = 'Journal Batches';
    DataCaptionExpression = DataCaption();
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    SourceTable = "Gen. Journal Batch";
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal you are creating.';
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a brief description of the journal batch you are creating.';
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a brief description of the journal batch you are creating.';
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Approval Status';
                }
                field("Voucher Name"; "Voucher Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Voucher Name for Posted Voucher Report';
                    Editable = false;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditJournal)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';
                ToolTip = 'Open a journal based on the journal batch.';

                trigger OnAction()
                begin
                    GenJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
            action("Create New Batch")
            {
                Caption = 'Create New Batch';
                ApplicationArea = All;
                Image = CreateLinesFromJob;
                ToolTip = 'Create New Batch';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    lGenJnlBatch: Record "Gen. Journal Batch";
                    lGenJnlTemp: Record "Gen. Journal Template";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    NoseriesCode: code[20];
                begin

                    if lGenJnlTemp.get("Journal Template Name") then begin
                        lGenJnlTemp.TestField("Batch No. Series");

                        lGenJnlBatch.init();
                        lGenJnlBatch."Journal Template Name" := "Journal Template Name";
                        NoSeriesMgt.InitSeries(lGenJnlTemp."Batch No. Series", lGenJnlTemp."Batch No. Series",
                        workdate(), lGenJnlBatch.Name, NoseriesCode);
                        lGenJnlBatch.Description := lGenJnlTemp."Batch Description";
                        lGenJnlBatch."Allow Multiple Voucher" := lGenJnlTemp."Allow Multiple Voucher";
                        lGenJnlBatch."Voucher Name" := lGenJnlTemp."Voucher Name";
                        lGenJnlBatch.SetupNewBatch();
                        lGenJnlBatch.insert();
                        rec := lgenjnlbatch;
                        GenJnlManagement.TemplateSelectionFromBatch(Rec);
                    end;
                end;
            }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if GenJnlTemplateName <> '' then
            "Journal Template Name" := GenJnlTemplateName;
        SetupNewBatch();
    end;

    trigger OnOpenPage()
    begin
        GenJnlManagement.OpenJnlBatch(Rec);
        ShowAllowPaymentExportForPaymentTemplate();
        // Doing this because if user is using web client then filters on REC are being removed
        // Since filter is removed we need to persist value for template
        // name and use it 'OnNewRecord'
        GenJnlTemplateName := "Journal Template Name";
    end;

    var
        GenJnlManagement: Codeunit GenJnlManagement;
        IsPaymentTemplate: Boolean;
        GenJnlTemplateName: Code[10];

    local procedure DataCaption(): Text[250]
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if not CurrPage.LookupMode then
            if GetFilter("Journal Template Name") <> '' then begin
                GenJnlTemplate.SetFilter(Name, GetFilter("Journal Template Name"));
                if GenJnlTemplate.FindSet() then
                    if GenJnlTemplate.Next() = 0 then
                        exit(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
            end;
    end;

    local procedure ShowAllowPaymentExportForPaymentTemplate()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        if GenJournalTemplate.Get("Journal Template Name") then
            IsPaymentTemplate := GenJournalTemplate.Type = GenJournalTemplate.Type::Payments;
    end;
}

