<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUI.Master" CodeBehind="ReportDocuments.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.ReportDocuments" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>
<%@ Register TagPrefix="uc" TagName="RepeatSchedule" Src="~/UserControls/RepeatSchedule.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        var selectedTab = $.cookie('ReportDocumentsSelectedTab') ? $.cookie('ReportDocumentsSelectedTab') : 'SingleUserReportTab';

        $(document).ready(function () {
            $("#" + selectedTab).find('a').click();

            $(".report-tabs li").on('shown.bs.tab', function (e) {
                var id = $(this).closest('li').attr('id');
                $.cookie('ReportDocumentsSelectedTab', id);
            });
        });

        function LoadDocumentTable(rows, table, removeFavCol) {
            $.each(rows, function (i, el) {
                addDocumentRow(table, el);
            });

            if (removeFavCol) {
                $(table).find('tbody tr td.fav-col').remove();
            };

            $(table).find('.marked-as-favorite').each(function (i, el) {
                el = $(el);
                if (el.data('checked')) {
                    el.attr('checked', 'checked');
                };
            });

            $(table).on('change', '.marked-as-favorite', function (e) {
                $.ajax({
                    type: "POST",
                    url: "../../ManageUPWebService.asmx/AddRemoveReportFromFavorite",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: JSON.stringify({ ischecked: $(this).is(':checked'), docID: $(this).data('docid') }),
                    success: function (data) {
                        console.log(data);
                    }
                });

                var favoriteTable = $('#FavoriteDocumentsGrid');
                if (favoriteTable.hasClass('dataTable')) {
                    var oTable = favoriteTable.DataTable();
                    oTable.destroy();
                };

                if ($(this).is(':checked')) {
                    addDocumentRow(favoriteTable, { DocID: $(this).data('docid'), DocumentName: $(this).data('name'), LastTimeEdited: $(this).data('last'), LastTimeEditedBy: $(this).data('lastby') });
                    $(favoriteTable).find('tbody tr:last td.fav-col').remove();
                }
                else {
                    favoriteTable.find('.reportdocument-' + $(this).data('docid')).remove();
                };

                favoriteTable.dataTable({ stateSave: true });
            });

            if (!$('#<%=createLink.ClientID%>').length) {
                $(table).find('.editable-content').remove();
            };

            $(table).dataTable({ stateSave: true });
        };

        function addDocumentRow(table, el) {
            $(table).append($('#document-row').tmpl(el));
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-content-wrapper">
        <div class="page-content">

            <h3 id="PageTitle" runat="server" class="hide-on-content-only page-title">Reports
            </h3>

            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="/dashjs/dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Reports</a>
                    </li>
                </ul>
            </div>

            <div class="row margin-bottom-15">
                <div class="col-md-6">
                    <a class="btn green" href="./createreportdoc.aspx" id="createLink" runat="server">Create&nbsp;
                        <i class="fa fa-plus"></i>
                    </a>
                </div>
            </div>

            <div class="row playbook">
                <div class="col-md-12">
                    <div class="portlet light">
                        <div class="portlet-title tabbable-line">
                            <ul class="nav nav-tabs report-tabs">
                                <li class="active" id="favorites-tab"><a href="#favoriteDocuments" class="withTooltip" data-title="Template Reports you have permission to view that you check as favorite in All Reports" data-type="favoriteDocuments" data-toggle="tab">
                                    <i class="fa fa-heart margin-right-10"></i>
                                    Favorites
                                </a></li>
                                <li id="my-reports-tab"><a href="#myDocuments" class="withTooltip" data-title="Template Reports that were created by you" data-type="myDocuments" data-toggle="tab">
                                    <i class="fa fa-file-text-o margin-right-10"></i>
                                    My Reports
                                </a></li>
                                <li id="all-reports-tab"><a href="#allDocuments" class="withTooltip" data-title="Template Reports that you have permission to view" data-type="allDocuments" data-toggle="tab">
                                    <i class="fa fa-files-o margin-right-10"></i>
                                    All Reports
                                </a></li>
                            </ul>
                        </div>

                        <div class="portlet-body">
                                    <asp:CheckBox ID="chkInactive" AutoPostBack="true" runat="server" Text="Include inactive reports" />
                        </div>

                        <div class="portlet-box">
                            <div class="tab-content">
                                <div class="tab-pane fade active in" id="favoriteDocuments">
                                    <table class="table table-bordered" id="FavoriteDocumentsGrid">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Last Edited</th>
                                                <th>Last Edited By</th>
                                                <th class="editable-content">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                <div class="tab-pane fade in" id="myDocuments">
                                    <table class="table table-bordered" id="MyDocumentsGrid">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Last Edited</th>
                                                <th>Last Edited By</th>
                                                <th class="editable-content">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                                <div class="tab-pane fade in" id="allDocuments">
                                    <table class="table table-bordered" id="AllDocumentsGrid">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Last Edited</th>
                                                <th>Last Edited By</th>
                                                <th>Favorite</th>
                                                <th class="editable-content">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/x-jquery-tmpl" id="document-row">
        <tr class="reportdocument-${DocID} {{if Archive == true }} warning {{/if}} ">
            <td><a href="ViewTemplateReport.aspx?ReportID=${DocID}">${DocumentName}</a></td>
            <td>${LastTimeEdited}</td>
            <td>${LastTimeEditedBy}</td>
            <td class="fav-col">
                <input type="checkbox" data-checked="${UserMarkedItAsFavorite}" data-docid="${DocID}" data-name="${DocumentName}" data-last="${LastTimeEdited}" data-lastby="${LastTimeEditedBy}" class="marked-as-favorite" />
            </td>
            <td class="editable-content">
                <a href="./createReportDoc.aspx?ReportID=${DocID}">Edit</a>&nbsp;
                <%if (this.HasAssignAccess())
                {%>
                    <a href="/dashjs/admin/ReportAssignment.aspx?ReportTemplateID=${DocID}">Assign</a>
                 <%} %>
            </td>
        </tr>
    </script>
</asp:Content>
