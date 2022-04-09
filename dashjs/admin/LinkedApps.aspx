<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" ClientIDMode="Static" AutoEventWireup="true" CodeBehind="LinkedApps.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.LinkedApps" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>
    
    <script>
        $(document).ready(function () {
            $(document).on('click', '#<%=unlinkBox.ClientID%>', function () {

                bootbox.confirm("If you unlink your Box account, every file related to it is going to become unavailable, are you sure you want to proceed?", function (proceed) {
                    if (proceed) {
                        call('/dashjs/admin/LinkedApps.aspx/UnlinkBox', null, function () { window.location.reload() });
                    };
                })
            });
        });
    </script>
    
    <style>
        .table-big tr {
            height: 40px;
        }
        .linked-app-list {
            list-style-type: none;
            vertical-align: central;
            margin-top: 50px;
        }
        .linked-app-list .linked-app-brand-image, .linked-app-list .linked-app-brand-image-last  {
            display: table-cell;
            list-style-type: none;
            padding-left: 20px;
            padding-right: 20px;
        }
        .linked-app-logo {
            width: 200px;
            filter: gray; /* IE6-9 */
            filter: grayscale(1); /* Microsoft Edge and Firefox 35+ */
            -webkit-filter: grayscale(1); /* Google Chrome, Safari 6+ & Opera 15+ */
            -webkit-transition: .2s ease-in-out;
            -moz-transition: .2s ease-in-out;
            -o-transition: .2s ease-in-out;
        }
        .linked-app-logo:hover {
            filter: none;
            -webkit-filter: grayscale(0);
            -webkit-transition: .2s ease-in-out;
            -moz-transition: .2s ease-in-out;
            -o-transition: .2s ease-in-out;
        }
        .logo-separator {
            height: 100px;
            border-right: dashed 2px lightgray;
            display: table-cell;
            list-style-type: none;
            padding-left: 20px;
        }
        hr.page-separator { 
            width: 50%;
            margin-left:25%;
            margin-top: 100px;
            margin-bottom: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <%--Admin Menu--%>
            <div class="portlet light bordered" data-team="false">
                <div class="portlet-title " style="border: none;">
                    <div class="tabbable-line col-md-9">
                        <ul class="nav nav-tabs home-tabs nav-justified task-widget" id="AdminTabs">
                            <asp:Literal ID="AdminMenu" runat="server" />
                        </ul>
                    </div>
                </div>
            </div>

            <div class="tab-content">
                <div class="tab-pane active" id="tab0">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption">Linked Apps</div>
                                </div>
                                <div class="portlet-body">
                                    <div class="table-scrollable table-scrollable-borderless">
                                        <table class="table table-hover table-light table-big">
                                            <thead>
                                                <tr>
                                                    <th> APP </th>
                                                    <th> STATUS </th>
                                                    <th> ACTIONS </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><img src="/dashjs/img/box_logo.png" width="45"/></td>
                                                    <td><asp:Label ID="BoxStatus" runat="server"></asp:Label></td>
                                                    <td>
                                                        <a href="#" class="btn" id="linkBox" runat="server">Link</a>
                                                        <a class="btn" id="unlinkBox" runat="server">Unlink</a>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <hr class="page-separator"/>
                                        <h4 style="text-align: center;"><img src="/_ima/logo-blue2.png" style="width: 200px; vertical-align: bottom; margin-bottom: -6px;"/> is also integrated with the following products</h4>
                                        <div class="linked-app-list col-md-offset-2">
                                            <div class="linked-app-brand-image">
                                                <img src="/dashjs/img/twilio_logo.png" class="linked-app-logo" />
                                            </div>
                                            <div class="logo-separator"></div>
                                            <div class="linked-app-brand-image">
                                                <img src="/dashjs/img/zoom_logo.png" class="linked-app-logo"/>
                                            </div>
                                            <div class="logo-separator"></div>
                                            <div class="linked-app-brand-image">
                                                <img src="/dashjs/img/Mandrill_logo.png" class="linked-app-logo"/>
                                            </div>
                                            <div class="logo-separator"></div>
                                            <div class="linked-app-brand-image-last">
                                                <img src="/dashjs/img/moodle-logo.png" class="linked-app-logo"/>
                                            </div>
                                        </div>
                                        <br />
                                        <br />
                                        <br />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <asp:HiddenField ID="BoxAuthIFrameSrc" runat="server" />


        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
</asp:Content>
