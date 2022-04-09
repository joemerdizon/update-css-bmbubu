<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KaizenLeaderboard.aspx.cs" Inherits="ManageUPPRM.dashjs.kaizen.KaizenLeaderboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="/Scripts/jquery-1.11.1.min.js"></script>
    <script src="/Scripts/jquery-ui-1.10.2.min.js"></script>
    <script src="/Scripts/jquery.tmpl.min.js"></script>

    <script src="../js/common.js"></script>



    <script src="/dashjs/js/bootstrap.js"></script>
    <script src="/dashjs/js/bootstrap-multiselect.js"></script>


    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

    <script src="/Content/bootstrap-modal.js"></script>
    <script src="/Content/bootstrap-tab.js"></script>

        <!-- Bootstrap core CSS -->
    <link href="style/bootstrap.min.css" rel="stylesheet">

        <link href="style/modal.css" rel="stylesheet">



    <script>

        var aspxPage = 'kaizen.aspx';

        $(document).ready(function () {
            getLeaders();
        });

        function getLeaders()
        {
            var result = callActionOnServer('getLeaderboard','', true, true);
            $('#leadersList').html($('#leaderboard-content').tmpl(result));
            //$('#modalLeaderboard').modal('show');

        }

        function callActionOnServer(action, params, showLoading, hideLoading)
        {
                var res;
                if (showLoading) processLoading();

                $.ajax({
                    type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
                    success: function (result) {
                        res = result.d;
                    },
                    failure: function (response) {
                        alert(response.d);
                    },
                    async: false
                });

                if (hideLoading) endProcessLoading();
                return res;
        }

        function processLoading()
        {
            $("#loading-modal").modal('show');

        }


        function endProcessLoading()
        {
            $("#loading-modal").modal('hide');
        }


    </script>
</head>
<body>
    
    

                            <script type="text/x-jquery-tmpl" id="leaderboard-content">
                    <div class="row datacontainer-leaderboard">
                        <div class="col-cus-3 leaderboard-right-seperator   "><input type="button" value="${categoryName}" class="button-modal-leaderboard"> </div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[0] != null }} ${scores[0].user.name} <br/>(${scores[0].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[1] != null }} ${scores[1].user.name} <br/>(${scores[1].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[2] != null }} ${scores[2].user.name} <br/>(${scores[2].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[3] != null }} ${scores[3].user.name} <br/>(${scores[3].score}) {{/if}}</div>
                        <div class="col-cus-2 leaderboard-right-seperator">{{if scores[4] != null }} ${scores[4].user.name} <br/>(${scores[4].score}) {{/if}}</div>

                        
                    </div>
                </script>

        
                <div class="row white-container row-custom">
                </div>
                <div class="row leaderboard-head">
                    <div class="col-cus-3 leaderboard-right-border">SQUEEZE Category</div>
                    <div class="col-cus-2 leaderboard-right-border">First</div>
                    <div class="col-cus-2 leaderboard-right-border">Second</div>
                    <div class="col-cus-2 leaderboard-right-border">Third</div>
                    <div class="col-cus-2 leaderboard-right-border">Fourth</div>
                    <div class="col-cus-2 leaderboard-right-border">Fifth</div>
                </div>

                <div id="leadersList"></div>


                <div id="loading-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="basicModal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header popheader-modal-tabular">
                        <h4 class="modal-title" id="myModalLabel">Working</h4>
                    </div>

                    <br /><br />
                    <div align="center">
                        <img src="/dashjs/js/img/ajax-loader.gif" />
                    </div>
                    <br /><br />
                    <div>
                    </div>
                </div>
            </div>
        </div>



</body>
</html>
