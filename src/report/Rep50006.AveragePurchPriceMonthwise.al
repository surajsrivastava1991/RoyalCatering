report 50006 "Average Purch. Price Monthwise"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/AvgPurchPriceMonthlyLayout.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            column(No_; "No.")
            {

            }
            column(Description; Description)
            {

            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = where("Entry Type" = const(Purchase));
                DataItemLink = "Item No." = field("No.");
                RequestFilterFields = "Posting Date";
                column(Cost_Amount__Actual_; "Cost Amount (Actual)")
                {

                }
                column(Posting_Date; "Posting Date")
                {

                }
                column(MonthVarText; MonthVarText)
                {

                }
                column(MonthVar; MonthVar)
                {

                }
                column(YearVar; YearVar)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                trigger OnAfterGetRecord()
                begin
                    CalcFields("Cost Amount (Actual)");
                    YearVar := Date2DMY("Posting Date", 3);
                    MonthVar := Date2DMY("Posting Date", 2);
                    MonthVarText := GetMonth();
                end;
            }
        }
    }

    var
        myInt: Integer;
        YearVar: Integer;
        MonthVar: Integer;
        MonthVarText: Text[10];

    procedure GetMonth(): Text[10]
    begin
        case MonthVar of
            1:
                exit('Jan');
            2:
                exit('Feb');
            3:
                exit('Mar');
            4:
                exit('Apr');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('Aug');
            9:
                exit('Sept');
            10:
                exit('Oct');
            11:
                exit('Nov');
            12:
                exit('Dec');
        end;
    end;
}