report 50051 "Banquet Event Report"
{
    Caption = 'Banquet Event Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './res/BanquetOrderLayout.rdl';

    dataset
    {
        dataitem(SalesOrder; "Sales Header")
        {
            column(Picture_; CompamyInfoG.Picture)
            {

            }
            column(No_; "No.")
            {
            }
            column(Beverages1; Beverages1)
            {
            }
            column(Beverages2; Beverages2)
            {
            }
            column(Engineering; Engineering)
            {
            }
            column(Equipment; Equipment)
            {
            }
            column(FoodBeveragesNotes; "Food & Beverages Notes")
            {
            }
            column(FoodMenu1; "Food Menu1")
            {
            }
            column(FoodMenu2; "Food Menu2")
            {
            }
            column(FoodMenu3; "Food Menu3")
            {
            }
            column(GuestExpected; "Guest Expected")
            {
            }
            column(GuestGuaranteed; "Guest Guaranteed")
            {
            }
            column(HKLines; "HK Lines")
            {
            }
            column(Housekeeping; Housekeeping)
            {
            }
            column(Hygiene; Hygiene)
            {
            }
            column(LocationBEO; "Location BEO")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(MenuPrice; "Menu Price")
            {
            }
            column(NoofPAX; "No. of PAX")
            {
            }
            column(Pricing; Pricing)
            {
            }
            column(RefferedBy; "Reffered By")
            {
            }
            column(SetupNotes; "Setup Notes")
            {
            }
            column(ServiceStyle; "Service Style")
            {
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(StaffAmount; "Staff (Amount)")
            {
            }
            column(TypeofEvent; "Type of Event")
            {
            }
            column(TypeofSale; "Type of Sale")
            {
            }
            column(TransportAmount; "Transport (Amount)")
            {
            }
            column(Venue; Venue)
            {

            }
            column(Date_of_function_start; "Date of function start")
            {

            }
            column(Date_of_function_end; "Date of function end")
            {

            }
            column(Start_Time; "Start Time")
            {

            }
            column(End_Time; "End Time")
            {

            }
            column(Prepared_By; "Prepared By")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            {

            }
            column(Sell_to_Contact; "Sell-to Contact")
            {

            }
            column(No__of_Archived_Versions; "No. of Archived Versions")
            {

            }
            column(Kitchen; Kitchen)
            {

            }
            column(Stewarding; Stewarding)
            {

            }
            column(Transportation; Transportation)
            {

            }
            column(Staffing; Staffing)
            {

            }
            column(Billing_Instruction; "Billing Instruction")
            {

            }
            column(Additional_Instructions; "Additional Instructions")
            {

            }
            column(ProjectID; DimSetEntrisG."Dimension Value Code")
            {

            }
            column(ProjectName; DimSetEntrisG."Dimension Value Name")
            {

            }
            column(Restrictions; Restrictions)
            {

            }
            column(Details_of_the_event; "Details of the event")
            {

            }
            trigger OnAfterGetRecord()
            begin
                IF DimSetEntrisG.GET("Dimension Set ID", 'PROJECT') then;
                DimSetEntrisG.CalcFields(DimSetEntrisG."Dimension Value Name");
            end;
        }
    }
    trigger OnPreReport()
    begin
        CompamyInfoG.GET();
        CompamyInfoG.CalcFields(Picture);
    end;

    var
        DimSetEntrisG: Record "Dimension Set Entry";
        CompamyInfoG: Record "Company Information";

}