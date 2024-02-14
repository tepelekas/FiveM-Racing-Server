var playerData = {};

$(document).ready(function () {
    $("#freeroam").click(function(){
        console.log('Freeroam button clicked');
    });

    $("#shop").click(function(){
        $.post('https://nfd-vehicleshop/openVehicleshop', JSON.stringify({
            action: 'openVehicleshop',
            invoker: 'resource'
        }));
        $('#lobby_container').hide();
    });

    $("#garage").click(function(){
        $.post('https://nfd-garage/openGarage', JSON.stringify({
            action: 'openGarage',
            invoker: 'resource'
        }));
        $('#lobby_container').hide();
    });

    $("#races").click(function(){
        console.log('Races button clicked');
    });

    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case 'openLobby':
                playerData = event.data.data;
                $('#moneyAmount').text(playerData.money);
                $('#lobby_container').show();
                break;
            case 'closeLobby':
                $('#lobby_container').hide();
                break;
        }
    })
});
