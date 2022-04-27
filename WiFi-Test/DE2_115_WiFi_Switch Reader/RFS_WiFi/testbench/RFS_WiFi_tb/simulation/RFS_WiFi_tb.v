// RFS_WiFi_tb.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module RFS_WiFi_tb (
	);

	wire         rfs_wifi_inst_clk_bfm_clk_clk;                                  // RFS_WiFi_inst_clk_bfm:clk -> [RFS_WiFi_inst:clk_clk, RFS_WiFi_inst_reset_bfm:clk]
	wire   [7:0] rfs_wifi_inst_pio_0_external_connection_bfm_conduit_export;     // RFS_WiFi_inst_pio_0_external_connection_bfm:sig_export -> RFS_WiFi_inst:pio_0_external_connection_export
	wire   [1:0] rfs_wifi_inst_pio_key_external_connection_bfm_conduit_export;   // RFS_WiFi_inst_pio_key_external_connection_bfm:sig_export -> RFS_WiFi_inst:pio_key_external_connection_export
	wire   [3:0] rfs_wifi_inst_pio_led_external_connection_export;               // RFS_WiFi_inst:pio_led_external_connection_export -> RFS_WiFi_inst_pio_led_external_connection_bfm:sig_export
	wire         rfs_wifi_inst_pio_wifi_reset_external_connection_export;        // RFS_WiFi_inst:pio_wifi_reset_external_connection_export -> RFS_WiFi_inst_pio_wifi_reset_external_connection_bfm:sig_export
	wire  [47:0] rfs_wifi_inst_seg7_if_0_conduit_end_export;                     // RFS_WiFi_inst:seg7_if_0_conduit_end_export -> RFS_WiFi_inst_seg7_if_0_conduit_end_bfm:sig_export
	wire         rfs_wifi_inst_wifi_uart0_external_connection_txd;               // RFS_WiFi_inst:wifi_uart0_external_connection_txd -> RFS_WiFi_inst_wifi_uart0_external_connection_bfm:sig_txd
	wire   [0:0] rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_cts_n; // RFS_WiFi_inst_wifi_uart0_external_connection_bfm:sig_cts_n -> RFS_WiFi_inst:wifi_uart0_external_connection_cts_n
	wire         rfs_wifi_inst_wifi_uart0_external_connection_rts_n;             // RFS_WiFi_inst:wifi_uart0_external_connection_rts_n -> RFS_WiFi_inst_wifi_uart0_external_connection_bfm:sig_rts_n
	wire   [0:0] rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_rxd;   // RFS_WiFi_inst_wifi_uart0_external_connection_bfm:sig_rxd -> RFS_WiFi_inst:wifi_uart0_external_connection_rxd
	wire         rfs_wifi_inst_reset_bfm_reset_reset;                            // RFS_WiFi_inst_reset_bfm:reset -> RFS_WiFi_inst:reset_reset_n

	RFS_WiFi rfs_wifi_inst (
		.clk_clk                                   (rfs_wifi_inst_clk_bfm_clk_clk),                                  //                                clk.clk
		.pio_0_external_connection_export          (rfs_wifi_inst_pio_0_external_connection_bfm_conduit_export),     //          pio_0_external_connection.export
		.pio_key_external_connection_export        (rfs_wifi_inst_pio_key_external_connection_bfm_conduit_export),   //        pio_key_external_connection.export
		.pio_led_external_connection_export        (rfs_wifi_inst_pio_led_external_connection_export),               //        pio_led_external_connection.export
		.pio_wifi_reset_external_connection_export (rfs_wifi_inst_pio_wifi_reset_external_connection_export),        // pio_wifi_reset_external_connection.export
		.reset_reset_n                             (rfs_wifi_inst_reset_bfm_reset_reset),                            //                              reset.reset_n
		.seg7_if_0_conduit_end_export              (rfs_wifi_inst_seg7_if_0_conduit_end_export),                     //              seg7_if_0_conduit_end.export
		.wifi_uart0_external_connection_rxd        (rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_rxd),   //     wifi_uart0_external_connection.rxd
		.wifi_uart0_external_connection_txd        (rfs_wifi_inst_wifi_uart0_external_connection_txd),               //                                   .txd
		.wifi_uart0_external_connection_cts_n      (rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_cts_n), //                                   .cts_n
		.wifi_uart0_external_connection_rts_n      (rfs_wifi_inst_wifi_uart0_external_connection_rts_n)              //                                   .rts_n
	);

	altera_avalon_clock_source #(
		.CLOCK_RATE (50000000),
		.CLOCK_UNIT (1)
	) rfs_wifi_inst_clk_bfm (
		.clk (rfs_wifi_inst_clk_bfm_clk_clk)  // clk.clk
	);

	altera_conduit_bfm rfs_wifi_inst_pio_0_external_connection_bfm (
		.sig_export (rfs_wifi_inst_pio_0_external_connection_bfm_conduit_export)  // conduit.export
	);

	altera_conduit_bfm_0002 rfs_wifi_inst_pio_key_external_connection_bfm (
		.sig_export (rfs_wifi_inst_pio_key_external_connection_bfm_conduit_export)  // conduit.export
	);

	altera_conduit_bfm_0003 rfs_wifi_inst_pio_led_external_connection_bfm (
		.sig_export (rfs_wifi_inst_pio_led_external_connection_export)  // conduit.export
	);

	altera_conduit_bfm_0004 rfs_wifi_inst_pio_wifi_reset_external_connection_bfm (
		.sig_export (rfs_wifi_inst_pio_wifi_reset_external_connection_export)  // conduit.export
	);

	altera_avalon_reset_source #(
		.ASSERT_HIGH_RESET    (0),
		.INITIAL_RESET_CYCLES (50)
	) rfs_wifi_inst_reset_bfm (
		.reset (rfs_wifi_inst_reset_bfm_reset_reset), // reset.reset_n
		.clk   (rfs_wifi_inst_clk_bfm_clk_clk)        //   clk.clk
	);

	altera_conduit_bfm_0005 rfs_wifi_inst_seg7_if_0_conduit_end_bfm (
		.sig_export (rfs_wifi_inst_seg7_if_0_conduit_end_export)  // conduit.export
	);

	altera_conduit_bfm_0006 rfs_wifi_inst_wifi_uart0_external_connection_bfm (
		.sig_cts_n (rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_cts_n), // conduit.cts_n
		.sig_rts_n (rfs_wifi_inst_wifi_uart0_external_connection_rts_n),             //        .rts_n
		.sig_rxd   (rfs_wifi_inst_wifi_uart0_external_connection_bfm_conduit_rxd),   //        .rxd
		.sig_txd   (rfs_wifi_inst_wifi_uart0_external_connection_txd)                //        .txd
	);

endmodule
