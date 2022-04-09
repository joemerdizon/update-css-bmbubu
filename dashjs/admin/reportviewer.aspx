<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" CodeBehind="reportviewer.aspx.cs" Inherits="ManageUPPRM.reportviewer"  %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>

    <meta charset="utf-8" />

    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />

    <link href="/assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="/assets/global/css/components.css" id="style_components" rel="stylesheet" type="text/css" />
    <link href="/assets/global/css/plugins.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/layout.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/custom.css" rel="stylesheet" type="text/css" />
    <link href="/assets/admin/layout/css/document.css" rel="stylesheet" type="text/css" />
    <link id="style_color" href="/assets/admin/layout/css/themes/darkblue.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="/_ima/favicon.ico" />
    <link href="/assets/global/plugins/bootstrap-datepicker/css/datepicker3.css" rel="stylesheet" type="text/css" />
    <link href="/assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <script src="/assets/global/plugins/jquery.min.js" type="text/javascript"></script>
    <script src="/assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="/assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>

    <script src="/assets/global/scripts/metronic.js" type="text/javascript"></script>
    <script src="/assets/admin/layout/scripts/layout.js" type="text/javascript"></script>
    <script type="text/javascript" src="/dashjs/js/common.js"></script>
    <script type="text/javascript">
        $(function () {
            $(".tooltips").tooltip();

            var fullScreenModal = $('#full-screen-modal');

            fullScreenModal.on('hidden.bs.modal', function () {
                location.reload();
            });
        });
    </script>
</head>
<body class="document-page">
    <div class="row">
        <div class="col-md-6">
            <span id="OrganizationName" runat="server" visible="false"></span>
            <img class="margin-top-5" runat="server" id="ReportClientLogo" src="" height="90" />
        </div>

        <div class="col-md-6 text-right">
            <h1>Report for <span id="EmployeeName" runat="server"></span></h1>
        </div>
    </div>
    <div class="row line-spacing">
        <div class="col-sm-6">

            <div class="group-info-wrapper">
                <label>Employee</label>
                <p class="info-name" runat="server" id="EmployeeName2"></p>
            </div>
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Department</label>
                <p class="info-name" runat="server" id="Department"></p>
            </div>

            <div class="clearfix"></div>
            <%if (reportTemplateAssignmentID.HasValue)
            {%>
                <div class="group-info-wrapper">
                    <label>Assignment Date</label>
                    <p class="info-name" runat="server" id="ReportAssignmentDate"></p>
                </div>
            <% }
            else
            {%>
                <div class="group-info-wrapper">
                    <label>Report Range</label>
                    <p class="info-name" runat="server" id="ReportRange"></p>
                </div>
            <%}%>
        </div>
        <div class="col-sm-6">
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Employee ID#</label>
                <p class="info-name signature-line"></p>
            </div>
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Report Name</label>
                <p class="info-name" runat="server" id="ReportName"></p>
            </div>
            <div class="clearfix"></div>
            <div class="group-info-wrapper">
                <label>Report Date</label>
                <p class="info-name" runat="server" id="ReportDate"></p>
            </div>
        </div>
    </div>

    <div class="row line-spacing">
        <div class="col-md-2">
            <label>PROGRESS BAR</label>
        </div>
        <div class="col-md-10">
            <div class="progress-bar-wrapper tooltips" runat="server" id="ProgressBarWrapper">
                <div class="progress-bar-completion" runat="server" id="ProgressBar"></div>
            </div>
        </div>
    </div>

    <asp:Literal runat="server" ID="ReportData"></asp:Literal>

    <div class="row line-spacing">
        <div class="col-md-4">
            <div class="group-info-wrapper">
                <label>Total Achievable Score</label>
                <p class="info-score" runat="server" id="TotalScore"></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="group-info-wrapper">
                <label>Completion Score</label>
                <p class="info-score" runat="server" id="CompletionScore"></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="group-info-wrapper">
                <label>Percent Complete</label>
                <p class="info-score" runat="server" id="PercentComplete"></p>
            </div>
        </div>
    </div>
    <div class="row line-spacing">
        <div class="col-md-12">
            <p class="signature-acknowledge">Comments</p>
        </div>
    </div>

    <div class="row line-spacing"></div>
    
    <!-- start row -->
    <div class="row" id="AssessmentActions" runat="server">
        <label class="col-sm-5 control-label">Action resulting from assessment:</label>
        <div class="col-sm-7">
            <div class="checkbox-list">
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" id="chkPromotion" value="option1" runat="server" />
                    </div>
                    Promotion
                </label>
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" id="chkDemotion" value="option2" runat="server" />
                    </div>
                    Demotion
                </label>
                <label class="checkbox-inline">
                    <div class="checker">
                        <input type="checkbox" id="chkMaintained" value="option3" runat="server" />
                    </div>
                    Maintained
                </label>
            </div>
        </div>
        <div class="signature-line margin-top-20"></div>
    </div>
    <div class="clearfix"></div>

    <div class="row margin-top-20">
        <div class="col-md-12">
            <div id="ReportTemplateFooter" runat="server">
            </div>
        </div>
    </div>
    <!-- end row -->

    <div class="row margin-top-20">
        <div class="col-md-12">
            <span class="pull-right ">
                <span style="vertical-align: bottom">Powered By&nbsp</span>
                <img src="/_ima/logo-blue2.png" width="168px" class="margin-top-20" />
            </span>
        </div>
    </div>

    
    <div id="full-screen-modal" class="modal fade bs-modal-lg" aria-hidden="true">
        <div class="modal-dialog modal-full">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body" style="min-height: 100px;">
                    <iframe src="" frameborder="0" width="98%"></iframe>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
