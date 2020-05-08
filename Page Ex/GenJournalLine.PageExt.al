pageextension 50042 "Gen journal line" extends "General Journal"
{
    layout
    {



        addafter("Shortcut Dimension 1 Code")
        {
            field("CL from Date"; "CL from Date")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation From Date';
            }
            field("CL To Date"; "CL To Date")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation To Date';
            }
            field("Bulk Kitchen"; "Bulk Kitchen")
            {
                ApplicationArea = all;
                ToolTip = 'Cost Allocation Bulk Allocation';
            }
            field("Batch Description"; "Batch Description")
            {
                ApplicationArea = all;
                ToolTip = 'Batch Decription for posted Voucher Report';
            }

        }
        // Add changes to page layout here
    }

    actions
    {
        modify(Post)
        {
            Visible = DocEnable;
        }
        addafter("Test Report")
        {
            action(Post1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                Visible = DocEnable1;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                var
                    costallocationL: Record "Cost Allocation Header";
                    GLentryL: Record "G/L Entry";
                    TD: Date;
                    FD: date;
                    LocationCodeL: Code[20];
                begin
                    TD := REC."CL To Date";
                    FD := REC."CL from Date";
                    LocationCodeL := rec."Bulk Kitchen";
                    GeneralLedgerSetup.get();
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                    CurrentJnlBatchName := GetRangeMax("Journal Batch Name");

                    if GeneralLedgerSetup."Post with Job Queue" then
                        NewDocumentNo();

                    GLentryL.Reset();
                    GLentryL.SetRange("CL from Date", FD);
                    GLentryL.SetRange("CL To Date", TD);
                    GLentryL.SetRange("Bulk Kitchen", LocationCodeL);
                    if GLentryL.FindFirst() then begin
                        costallocationL.Reset();
                        costallocationL.SetRange("from Date", FD);
                        costallocationL.SetRange("To Date", TD);
                        costallocationL.SetRange("Bulk Location", LocationCodeL);
                        if costallocationL.FindFirst() then begin
                            costallocationL."Voucher No. (Posted)" := GLentryL."Document No.";
                            costallocationL."Journal Posted" := true;
                            costallocationL.Modify(true);
                        end;
                    end;
                end;
            }
        }       // Add changes to page actions here\
    }

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrentJnlBatchName: Code[10];
        DocEnable: Boolean;
        DocEnable1: Boolean;

    trigger OnAfterGetRecord()
    begin

        if ("CL To Date" <> 0D) and ("CL To Date" <> 0D) and ("Bulk Kitchen" <> '')
        then begin
            DocEnable := false;
            DocEnable1 := true;
        end else begin
            DocEnable := true;
            DocEnable1 := false;
        end;
    end;

    trigger OnOpenPage()
    begin
        if ("CL To Date" <> 0D) and ("CL To Date" <> 0D) and ("Bulk Kitchen" <> '')
           then begin
            DocEnable := false;
            DocEnable1 := true;
        end else begin
            DocEnable := true;
            DocEnable1 := false;
        end;

    end;
}