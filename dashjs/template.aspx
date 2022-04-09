<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="template.aspx.cs" Inherits="ManageUPPRM.template" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">

    <meta charset="utf-8" />
    <title>ManageUP PRM</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <!-- Le styles -->
    <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/bootstrap-responsive.css" rel="stylesheet" />
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->
    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png" />
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png" />
    <link rel="shortcut icon" href="../assets/ico/favicon.png" />

    <script src="js/bootstrap-modal.js"></script>
    <script src="js/bootstrap-tab.js"></script>
</head>

<body>
    <form runat="server">
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
                            <h5></h5>
                            <img width="200" src="img/MU-logo_WhiteText.png" />
                        </div>
                    </div>
                    <div class="nav-collapse collapse">
                        <ul class="nav">
                            <li><a href="../dashjs/dashboardjsNew.aspx">UPSPACE</a></li>
                            <li class="active"><a href="#">TEAM</a></li>
                            <li><a href="../dashjs/schedule.aspx">SCHEDULE</a></li>
                            <li><a href="#">PLAYBOOK</a></li>
                            <li><a href="#">COMMUNITY</a></li>
                            <li><a href="../dashjs/admin/admin.aspx">SUPPORT</a></li>
                            <li><a href="../logincontroller.aspx?ac=logoff">LOGOFF</a></li>
                        </ul>
                    </div>
                    <!--/.nav-collapse -->
                </div>
            </div>
        </div>

        <div class="container">
            <div class="main-container span9">
            </div>
            <div class="sidebar span3">
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
        <!-- Le javascript
    ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <!--<script src="js/jquery.js"></script>-->
        <%--    <script src="js/bootstrap-transition.js"></script>
    <script src="js/bootstrap-alert.js"></script>--%>

        <%--    <script src="js/bootstrap-dropdown.js"></script>
    <script src="js/bootstrap-scrollspy.js"></script>

    <script src="js/bootstrap-tooltip.js"></script>
    <script src="js/bootstrap-popover.js"></script>
    <script src="js/bootstrap-button.js"></script>
    <script src="js/bootstrap-collapse.js"></script>
    <script src="js/bootstrap-carousel.js"></script>
    <script src="js/bootstrap-typeahead.js"></script>--%>

        <div id="SQEEZEModal" class="modal hide fade">
            <div class="modal-header">
                <a href="#" class="close" data-dismiss="modal">&times;</a>
                <h3 id="H1">Score Chart</h3>
            </div>

            <div class="modal-body">
                <div class="squeeze-container">
                    <h4>Individual Score</h4>
                    <ul>
                        <li>
                            <div class="level">LEVEL</div>
                            <div class="progress-bar" id="divscore1">S</div>
                            <span id="score1"></span></li>
                        <li>
                            <div class="level">LEVEL</div>
                            <div class="progress-bar" id="divscore2">QU</div>
                            <span id="score2"></span></li>
                        <li>
                            <div class="level">LEVEL</div>
                            <div class="progress-bar" id="divscore3">E</div>
                            <span id="score3"></span></li>
                        <li>
                            <div class="level">LEVEL</div>
                            <div class="progress-bar" id="divscore4">E</div>
                            <span id="score4"></span></li>
                        <li>
                            <div class="level">LEVEL</div>
                            <div class="progress-bar" id="divscore5">ZE</div>
                            <span id="score5"></span></li>
                    </ul>
                    <!--end of squeeze-container-->
                </div>

                <div class="squeeze-container">
                    <h4>Leaderboard</h4>
                    <asp:GridView ID="LeaderboardGrid" CssClass="table table-bordered" runat="server" AutoGenerateColumns="false" OnRowDataBound="Leaderboard_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="Category">
                                <ItemTemplate>
                                    <div class="progress-bar" id="CatImg" runat="server"></div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="First (score)">
                                <ItemTemplate>
                                    <asp:Label ID="First" runat="server"></asp:Label>
                                    <asp:Literal ID="FirstScore" runat="server"></asp:Literal>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Second (score)">
                                <ItemTemplate>
                                    <asp:Label ID="Second" runat="server"></asp:Label>
                                    <asp:Literal ID="SecondScore" runat="server"></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Third (score)">
                                <ItemTemplate>
                                    <asp:Label ID="Third" runat="server"></asp:Label>
                                    <asp:Literal ID="ThirdScore" runat="server"></asp:Literal>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <div class="modal-footer">
                <input type="button" value="Close" class="btn btn-success" onclick="CloseSQModal();" />
            </div>
        </div>

        <div id="MessageModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3 id="H2">Send Message</h3>
            </div>
            <div class="modal-body">
                <div>
                    <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-home"></i></a>
                    <a href="#" class="btn btn-small"><i class="icon-file"></i></a>
                    <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-time"></i></a>
                    <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-pencil"></i></a>
                    <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-comment"></i></a>
                    <a href="javascript:GenericComingSoon();" class="btn btn-small"><i class="icon-headphones"></i></a>
                </div>

                <div style="padding-top: 20px">
                    <h2>Personal Message</h2>
                    <table class="table table-bordered">
                        <tr>
                            <td>
                                <div>Send To</div>
                                <asp:Label ID="ToUserFullName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>Title</div>
                                <asp:TextBox runat="server" ID="MessageHeader" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>Message</div>
                                <textarea id="MessageBody" cols="100" rows="5" runat="server"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <input type="button" class="btn btn-success" value="Send" onclick="SendMessage();" />
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>

        <div id="SendMessageGeneric" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3 id="H3"></h3>
            </div>
            <div class="modal-body">
                <p id="errorbody"></p>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>

        <div id="LoggedModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h3 id="H4">Availablity Status</h3>
            </div>
            <div class="modal-body">
                <h2 id="AvailabiltyStatus"></h2>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            </div>
        </div>

        <div id="GenericComingSoon" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="windowTitleLabel" aria-hidden="true">
            <div class="modal-header">
            </div>
            <div class="modal-body">
                <h2>Coming soon...</h2>
            </div>
            <div class="modal-footer">
                <a href="#" class="btn btn-success" onclick="DismissGenericComingSoon();">OK</a>
            </div>
        </div>
    </form>
</body>
</html>