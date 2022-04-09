<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="ManageUPPRM.admin" EnableEventValidation="false" EnableViewStateMac="false" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<!DOCTYPE HTML>
<html>
<head>
    <title>Admin</title>

    <script src="../../Scripts/jquery-2.1.0.js"></script>
    <script src="../../Content/bootstrap-modal.js"></script>
    <script src="../../Content/bootstrap-tab.js"></script>
    <script src="../../Content/bootstrap-dropdown.js"></script>
    <script src="../../admin/admin.js"></script>
    <script src="<%= Page.ContentLastWrite("/dashjs/js/keepAuthenticationAlive.js")%>"></script>

    <link href="../css/bootstrap.css" rel="stylesheet" />
    <link href="//code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" rel="search" />

    <link href="../../Content/dataTables.bootstrap.css" rel="stylesheet" />
    <link href="../../Content/jquery.dataTables.css" rel="stylesheet" />

    <link href="../../dashjs/css/site.css" rel="stylesheet" />
    <link href="../../dashjs/css/bootstrap.css" rel="stylesheet" />
    <link href="../../dashjs/css/bootstrap-responsive.css" rel="stylesheet" />
    <link href="../../admin/css/admin.css" rel="stylesheet" />
</head>

<body>
    <form id="MainForm" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
                    <div class="top-container">
                        <div class="span9 fltL">
                            <h1><a class="brand" href="#">
                                <asp:Literal ID="ClientTitle" runat="server"></asp:Literal>&nbsp<span><asp:Literal ID="ClientBranding" runat="server"></asp:Literal></span></a></h1>
                        </div>
                        <div class="span3 fltR">
                            <h5>&nbsp;</h5>
                            <img width="200" src="../img/MU-logo_WhiteText.png" />
                        </div>
                    </div>
                    <div class="nav-collapse collapse">
                        <ul class="nav">
                            <li><a href="../dashboardjsNew.aspx">UPSPACE</a></li>
                            <li><a href="../team.aspx">TEAM</a></li>
                            <li><a href="../schedule.aspx">SCHEDULE</a></li>
                            <li><a href="../processes.aspx">PLAYBOOK</a></li>
                            <li><a href="../blog.aspx">COMMUNITY</a></li>
                            <li class="active"><a href="admin.aspx">SUPPORT</a></li>
                            <li><a href="../../logincontroller.aspx?ac=logoff">LOGOFF</a></li>
                        </ul>
                    </div>
                    <!--/.nav-collapse -->
                </div>
            </div>
        </div>

        <div class="container" style="height: 700px;">
            <div class="main-container span12">
                <div class="row-fluid">
                    <div class="tabbable">
                        <!-- Only required for left/right tabs -->
                        <ul class="nav nav-tabs" id="AdminTabs">
                            <li id="AdminTab0" class="active"><a href="#tab0" data-toggle="tab">
                                <h2>Clients</h2>
                            </a></li>
                            <li id="AdminTab1"><a href="#tab1" data-toggle="tab">
                                <h2>Users</h2>
                            </a></li>
                            <li id="AdminTab2"><a href="#tab2" data-toggle="tab">
                                <h2>Departments</h2>
                            </a></li>
                            <li id="AdminTab3"><a href="#tab3" data-toggle="tab">
                                <h2>Site settings</h2>
                            </a></li>
                            <li id="AdminTab4"><a href="#tab4" data-toggle="tab">
                                <h2>My Profile</h2>
                            </a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tab0">
                                <h3>Client List</h3>
                                <div id="#ClientList" class="row-fluid" style="height: 500px">
                                </div>
                            </div>

                            <div class="tab-pane" id="tab1">
                                Users
                                <div class="form-group">
                                    <label for="inputEmail">Email</label>
                                    <input type="email" class="form-control" id="inputEmail" placeholder="Email">
                                </div>
                                <div class="form-group">
                                    <label for="inputPassword">Password</label>
                                    <input type="password" class="form-control" id="inputPassword" placeholder="Password">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox">
                                        Remember me</label>
                                </div>
                                <button type="submit" class="btn btn-primary">Login</button>
                            </div>

                            <div class="tab-pane" id="tab2">
                                Departments
                            </div>
                            <div class="tab-pane" id="tab3">
                                Site Settings
                            </div>
                            <div class="tab-pane" id="tab4">
                                My Profile
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /container -->
        <div class="footer-container navbar-fixed-bottom">
            <div class="footer">
                <div class="span12">
                    <ul>
                        <asp:Literal ID="FooterNav" runat="server"></asp:Literal>
                    </ul>
                    <!--end of span12-->
                </div>
                <div class="span12 txtR">
                    <p>© ManageUP PRM Copyright 2013</p>
                    <!--end of span12-->
                </div>
            </div>
            <!--end of footer-container-->
        </div>

        <div id="GenericMessage" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            </div>
            <div class="modal-body">
                <h3 id="GenericMessageHeader"></h3>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>

        <!-- /container -->
    </form>
</body>
</html>