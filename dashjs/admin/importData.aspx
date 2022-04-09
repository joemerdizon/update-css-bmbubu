<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="importData.aspx.cs" Inherits="ManageUPPRM.importData" EnableEventValidation="false" EnableViewStateMac="false" %>
<%@ Import Namespace="ManageUPPRM.Catalogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../admin/admin.js"></script>
    <script>
        $(document).ready(function () {
            $('#tabPermissions').DataTable({
                ordering: false,
                paging: false
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="hidden" id="selectedClient" runat="server" />
    <input type="hidden" id="adminUserCreation" runat="server" />
    <input type="hidden" id="successMsj" runat="server" />

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

            <%--Page Title--%>
            <div class="row-fluid">
                <h3 class="page-title">Import/Export Data</h3>
                <div class="note note-warning">
                    <h4 class="block">Use this module to import and export data from/to excel files</h4>
                    <p><b>Do not forget!</b> Excel files should respect a specific format. Example files are included on each importation module</p>
                </div>
            </div>

            <%--Actions--%>
            <div class="tab-content">
                <div class="tab-pane active" id="tab0">
                    <div class="row-fluid">
                        <div id="success-msg" class="alert alert-success span12" style="display: none;">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="portlet light bordered">
                                <div class="portlet-body todo-project-list-content">
                                    <ul class="nav nav-stacked">
                                        <li><a href="dataImporters/departments.aspx"><i class="fa fa-building"></i> Departments</a></li>
                                        <li><a href="dataImporters/roles.aspx"><i class="fa fa-sitemap"></i> Operational Roles (User Titles)</a></li>
                                        <li><a href="dataImporters/clientTitles.aspx"><i class="fa fa-users"></i> Functional Roles (Client Titles)</a></li>
                                        <li><a href="dataImporters/users.aspx"><i class="fa fa-user"></i> Users</a></li>
                                        <li><a href="dataImporters/permissions.aspx"><i class="fa fa-lock"></i> Permissions</a></li>
                                    </ul>
                                    <hr />
                                    <ul class="nav nav-stacked">
                                        <li role="separator" class="divider"></li>
                                        <% if (getRole() == RolesValues.Admin)
                                           { %>
                                        <li><a href="dataImporters/categories.aspx"><i class="fa fa-tags"></i> Task Categories and Sub Categories</a></li>
                                        <% } %>
                                        <li><a href="dataImporters/playbookExcelParser.aspx"><i class="fa fa-folder-open"></i> Playbook Data</a></li>
                                        <li><a href="dataImporters/TemplateTasks.aspx"><i class="fa fa-file"></i> Template Tasks Data</a></li>
                                        <li><%--<a href="dataImporters/TemplateTaskAssignment.aspx"><i class="fa fa-arrow-circle-right"></i> Assign Template Tasks </a>--%></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
</asp:Content>
