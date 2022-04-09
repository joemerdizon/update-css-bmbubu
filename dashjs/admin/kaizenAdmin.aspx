<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/Master.Master" CodeBehind="kaizenAdmin.aspx.cs" Inherits="ManageUPPRM.kaizenAdmin" EnableEventValidation="false" EnableViewStateMac="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/jquery-2.1.0.js"></script>
    <script src="../js/dataTables/jquery.dataTables.js"></script>
    <script src="../js/dataTables/dataTables.bootstrap.js"></script>
    <script src="../../Content/bootstrap-modal.js"></script>
    <script src="../../Content/bootstrap-tab.js"></script>
    <script src="../../Content/bootstrap-dropdown.js"></script>
    <script src="../../admin/admin.js"></script>
    <script src="../js/common.js"></script>
    <script src="../js/users.js"></script>
    <script src="../js/bootstrap-datepicker.js"></script>
    <script src="../../Scripts/jquery.isloading.js"></script>

    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" rel="search" />

    <link href="../../Content/dataTables.bootstrap.css" rel="stylesheet" />
    <link href="../../Content/jquery.dataTables.css" rel="stylesheet" />

    <link href="../../dashjs/css/site.css" rel="stylesheet" />
    <link href="../../dashjs/css/bootstrap.css" rel="stylesheet" />
    <link href="../../dashjs/css/bootstrap-responsive.css" rel="stylesheet" />
    <link href="../../admin/css/admin.css" rel="stylesheet" />
    <link href="../../dashjs/css/site.css" rel="stylesheet" />
    <link href="../../dashjs/css/fuelux.css" rel="stylesheet" />
    <link href="../../dashjs/css/datepicker.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


        <div class="container" style="min-height: 200px;">
            <div class="main-container">
                <div class="row-fluid">
                    <div class="tabbable">
                        <!-- Only required for left/right tabs -->
                        <ul class="nav nav-tabs" id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                    </div>

                                    <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Automatic Score for new entries</label>
                    <div class="controls">
                        <input id="txtPointsCreate" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>
                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score unit for scoring (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtPointsScore" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>
                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for replies (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtPointsReply" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>


                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing title (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtTitle" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing description (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtDescription" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing question 1 (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtQuestion1" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing question 2 (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtQuestion2" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing question 3 (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtQuestion3" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing Each Why (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtWhys" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>

                <div class="control-group" id="groupTitle">
                    <label class="control-label" for="fname">Score for completing Each Attachment (5,10,etc)</label>
                    <div class="controls">
                        <input id="txtAttachments" runat="server" class="form-control custom-border-leaderboard" type="text" >
                    </div>
                </div>


                <div runat="server" style="color: #FF0000" id="labErrors">

                </div>

                <asp:Button ID="butProcess" runat="server" Text="Save" class="btn btn-success"  OnClick="doSave" />
    

                </div>
            </div>
        </div>
        <!-- /container -->
    
        <!-- /container -->

            <div class="container" style="min-height: 200px;">
            <div class="main-container">
                <div class="row-fluid">

                </div>
            </div>
        </div>
</asp:Content>