<%@ Page Title="" Language="C#" MasterPageFile="~/MasterNewUI.Master" AutoEventWireup="true" CodeBehind="documents.aspx.cs" Inherits="ManageUPPRM.dashjs.documents" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            $("#ReportsLog").DataTable({
                stateSave: true,
                "aoColumnDefs": [
                    { "searchable": false, "targets": 3 }
                ]
            });

            $('body').on('click', 'a.archive-or-unarchive', function () {
                var reportID = $(this).data('reportid');

                callWebService({
                    data: JSON.stringify({ reportID: reportID }),
                    url: "/ManageUpWebService.asmx/ArchiveOrUnarchiveReportDocLog",
                    success: function (data) {
                        reloadDocuments();
                    },
                    blockTarget: $('#doc-list-container')
                });

                return false;
            });

            $('#show-archived-reports, #show-archived-multi-report').on('change', function () {
                reloadDocuments();
            });


            var reloadDocuments = function () {
                callWebService({
                    url: "documents.aspx/GetDocuments",
                    data: JSON.stringify({ includeArchived: $('#show-archived-reports').is(':checked') }),
                    success: function (data) {
                        $('#doc-list-container').html(data.d);
                        $('#doc-list-container table').dataTable({
                            stateSave: true,
                            "aoColumnDefs": [
                                { "searchable": false, "targets": 3 }
                            ]
                        });
                    },
                    blockTarget: $('#doc-list-container')
                });
            };
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div id="success-msg" class="alert alert-success span12" style="display: none;">
                </div>
            </div>


            <div class="row margin-top-15">
                <div class="col-md-12">
                    <div class="portlet box green" data-team="false">
                        <div class="portlet-title" style="border: none;">
                            <div class="caption">
                                MY GENERATED REPORTS
                            </div>
                        </div>

                        <div class="portlet-body" style="position: relative;">
                            
                            <div class="row playbook">
                                <div class="col-md-12">
                                    <div class="portlet box">
                                        <div class="portlet-body">
                                            <div class="row margin-bottom-15">
                                                <div class="col-md-12">
                                                    <div class="md-checkbox-list">
                                                        <div class="md-checkbox">
                                                            <input type="checkbox" id="show-archived-reports" class="md-check" />
                                                            <label for="show-archived-reports">
                                                                <span class="check"></span>
                                                                <span class="box"></span>
                                                                Show Archived Reports
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12" id="doc-list-container">
                                                    <asp:Literal ID="DocList" runat="server" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="modals" runat="server">
</asp:Content>
