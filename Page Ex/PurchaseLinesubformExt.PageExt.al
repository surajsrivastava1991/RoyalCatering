pageextension 50026 "Purchase Line subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            Editable = false;
        }
        modify("Direct Unit Cost")
        {
            Editable = EditableG;
        }
        addafter(Quantity)
        {
            field("Qty. to Accept"; "Qty. to Accept")
            {
                Caption = 'Quantity Excl. Over-delivery';
                ApplicationArea = all;
                ToolTip = 'Quantity Excl. Over-delivery';
            }
        }
        // Add changes to page layout here
        addafter("Line Amount")
        {
            field("Vendor Trade Agreement"; "Vendor Trade Agreement")
            {
                ApplicationArea = all;
                ToolTip = 'Based on purchase Price availability, it will enable for Direct Approval';
            }
        }
        addafter("Qty. to Receive")
        {

            field("Qty To Reject"; "Qty To Reject")
            {
                ApplicationArea = all;
                ToolTip = 'Quantity To be Rejected';
            }

            field("Exceed Qty."; "Exceed Qty.")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Exceed qty which should allow to accept';
            }
            field("Rejected Qty."; "Rejected Qty.")
            {
                ApplicationArea = all;
                ToolTip = 'Rejected Qty. which gone to rejected location';
            }
        }
        addafter("Qty. to Invoice")
        {
            field("Qty under delivery"; "Qty under delivery")
            {
                ApplicationArea = All;
                ToolTip = 'Which will not be received in future.';
            }
            field("Depreciation Book Code"; "Depreciation Book Code")
            {
                ApplicationArea = ALL;
                ToolTip = 'Depreciation Book Code';
            }
        }

    }
    var
        EditableG: Boolean;

    trigger OnAfterGetRecord()
    begin
        if "Vendor Trade Agreement" then
            EditableG := false
        else
            EditableG := true;

    end;

    trigger OnOpenPage()
    begin
        if "Vendor Trade Agreement" then
            EditableG := false
        else
            EditableG := true;

    end;
}