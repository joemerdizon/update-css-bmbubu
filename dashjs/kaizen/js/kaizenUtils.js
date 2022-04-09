function openLeaderboard(path)
{
    //var result = callActionOnServer('getLeaderboard','', true, true);
    //$('#leadersList').html($('#leaderboard-content').tmpl(result));

    var p = '';
    if (path!=null) p = path;
    document.getElementById('iframeLeaderboard').src = p + 'kaizenLeaderboard.aspx'; 
    document.getElementById('iframeLeaderboard').style.display = 'inline';
    $('#modalLeaderboard').modal('show');


}

