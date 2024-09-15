//TESTBEANCH 1 PER TEA
module tb_tea_1;

//SEGNALI CLOCK E RESET
  //Creo clock da 10ns
  reg clk = 1'b0;
  reg rst_n=1'b0;

  always #5 clk = !clk; 
  //Creo segnale di reset

initial #14.5 rst_n = 1'b1;

reg key_valid = 1'b0, ptxt_valid=1'b0;

reg [63:0] ptxt = 64'b0;
reg [127:0] key = 128'b0;
reg [63:0] ctxt = 64'b0;
reg [63:0] expected_ct;
reg ctxt_ready= 1'b0;

tiny_encryption_algorithm tea(
    .clk(clk),
    .rst_n(rst_n),
    .key_valid(key_valid),
    .ptxt_valid(ptxt_valid),
    .ptxt(ptxt),
    .key(key),
    .ctxt(ctxt),
    .ctxt_ready(ctxt_ready)
);

initial begin
    @(posedge rst_n);
    @(posedge clk);
    
    ptxt = 64'h18E529C5EF988A23;
    key = 128'hACA648FF30F3A45F8AE8F6D9F6027C41;
    expected_ct = 64'h9327C49731B08BBE;

    @(posedge clk);

    key_valid = 1'b1;
    ptxt_valid = 1'b1;

    @(posedge clk);
    key_valid = 1'b0;
    ptxt_valid = 1'b0;

    wait(ctxt_ready)
    @(posedge clk);

    $display("PTXT_VALIDO: %b - KEY_VALIDA: %b - CTXT_PRONTO: %b - %-5s - CTXT: %h", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b1 ? "OK" : "ERRORE", ctxt);
    ctxt_ready = 1'b0;
    @(posedge clk);

    // CASO PTXT_VALID = 0 - KEY_VALID = 0
    rst_n = !rst_n;
    @(posedge clk);
    rst_n = !rst_n;

    
    
    ptxt = 64'h18E529C5EF988A24;
    key = 128'hACA648FF30F3A45F8AE8F6D9F6027C41;
    @(posedge clk);

    
    key_valid = 1'b0;
    ptxt_valid = 1'b0;



    for (int i = 0; i < 2; i++)begin
        @(posedge clk);
    end

    $display("PTXT_VALIDO: %b - KEY_VALIDA: %b - CTXT_PRONTO: %b - %-5s - CTXT: %h", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b1 ? "OK" : "ERRORE", ctxt);



    // CASO PTXT_VALID = 0 - KEY_VALID = 1
    rst_n = !rst_n;
    @(posedge clk);
    rst_n = !rst_n;

    
    
    ptxt = 64'h18E529C5EF988A25;
    key = 128'hACA648FF30F3A45F8AE8F6D9F6027C41;
    @(posedge clk);

    
    key_valid = 1'b1;
    ptxt_valid = 1'b0;



    for (int i = 0; i < 2; i++)begin
        @(posedge clk);
    end

    $display("PTXT_VALIDO: %b - KEY_VALIDA: %b - CTXT_PRONTO: %b - %-5s - CTXT: %h", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b1 ? "OK" : "ERRORE", ctxt);

    // CASO PTXT_VALID = 1 - KEY_VALID = 0
    rst_n = !rst_n;
    @(posedge clk);
    rst_n = !rst_n;

    
    
    ptxt = 64'h18E529C5EF988A26;
    key = 128'hACA648FF30F3A45F8AE8F6D9F6027C41;
    @(posedge clk);

    
    key_valid = 1'b0;
    ptxt_valid = 1'b1;



    for (int i = 0; i < 2; i++)begin
        @(posedge clk);
    end

    $display("PTXT_VALIDO: %b - KEY_VALIDA: %b - CTXT_PRONTO: %b - %-5s - CTXT: %h", ptxt_valid, key_valid, ctxt_ready, ctxt_ready === 1'b1 ? "OK" : "ERRORE", ctxt);

$stop;
end

endmodule