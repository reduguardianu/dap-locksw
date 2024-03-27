function powerManagemenetInhibitated(main, cookie) {
    main.inhibitated = true;
    main.cookie = true;
        main.symbol = root.symbol_inhibitated;
        main.color = root.color_inhibitated;
}
function powerManagementRestored(main)
{
    main.inhibitated = false;
    main.cookie = -1;
    if (main.has_inhibitions) {
        main.symbol = root.symbol_inhibitions;
        main.color = root.color_inhibitions;
    } else {
        main.symbol = root.symbol_restrained;
        main.color = root.color_restrained;
    }
}
