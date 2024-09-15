//TESTBEANCH FOR TEA

module tb_tea_functional;
    
  //Creo clock da 10ns
  reg clk = 1'b0;
  always #5 clk = !clk; 
  
  //Creo segnale di reset
   reg rst_n = 1'b0;
  
  // Triggering of rst_n signal
  initial #14.5 rst_n = 1'b1;
  
  reg	              	key_valid   = 1'b0;    		 // 1 = se la chiave è stabile e valida, 0 = altrimenti
  reg		            ptxt_valid  = 1'b0;     	// 1 = se il plaintext è stabile e valido, 0 = altrimenti
  reg      [63:0]   	ptxt    	= 64'b0; 		// plaintext
  reg      [127:0]  	key         = 128'b0; 		// key
  reg      [63:0]   	expected_ct = 64'b0; 		// ciphertext atteso (letto dal file)
  
  wire     [63:0]  		ctxt;               		// ciphertext
  wire	            	ctxt_ready;        	 		// 1 = se il ciphertext è pronto, 0 = altrimenti
  
 
  // Istanzio il modulo da testare
  tiny_encryption_algorithm tea (
     .clk                       (clk)
    ,.rst_n                     (rst_n)
    ,.key_valid                 (key_valid)
    ,.ptxt_valid                (ptxt_valid)
    ,.ptxt                      (ptxt)
    ,.key                       (key)
    ,.ctxt                      (ctxt)
    ,.ctxt_ready                (ctxt_ready)
  );

  // // Creo file descriptor per ogni file di test 
  integer  key_file; 	// utilizzato per aprire il file keys.txt
  integer  pt_file; 	// utilizzato per aprire il file pt.txt
  integer  ct_file;		// utilizzato per aprire il file ct.txt
  integer  scan_file = 0; // utilizzato per controllare se la lettura del file è andata a buon fine

  // Registri temporanei che memorizzano un valore letto da un file specifico
  reg [127:0] tmp_key = 128'b0;
  reg [63:0]  tmp_pt  = 64'b0;
  reg [63:0]  tmp_ct  = 64'b0;

  initial begin

	key_file = $fopen("tv/keys.txt", "r");
	pt_file = $fopen("tv/pt.txt", "r");
	ct_file = $fopen("tv/ct.txt", "r");

	if (!key_file) begin
		$display("Il file keys.txt non esiste");
		$stop;
	end
	 if (!pt_file) begin
		$display("Il file pt.txt non esiste");
		$stop;
	end
	if (!ct_file) begin
		$display("Il file ct.txt non esiste");
		$stop;
	end
	$display("    PLAINTEXT   |   CIPHERTEXT   | EXPECTED CIPHERTEXT");
  end  

  always @(posedge clk) begin
	// Lettura del plaintext, della chiave e del ciphertext atteso dai file specifici
	scan_file = $fscanf(key_file, "%h\n", tmp_key);  // Leggo la chiave da file e la salvo in tmp_key
	scan_file = $fscanf(pt_file, "%h\n", tmp_pt);   // Leggo il plaintext da file e lo salvo in tmp_pt
	scan_file = $fscanf(ct_file, "%h\n", tmp_ct);  // Leggo il ciphertext atteso da file e lo salvo in tmp_ct

  // Controllo che non è ancora stato raggiunto per tutti i file del vettore di test EOF (End Of File)
	if (!$feof(key_file) && !$feof(pt_file) && !$feof(ct_file)) begin
	
		// Imposto le porte di input del modulo
		// @(posedge clk); 
		key         <= tmp_key;
		ptxt        <= tmp_pt;
		ptxt_valid  <= 1'b1;
		key_valid   <= 1'b1;
		 
		expected_ct = tmp_ct;

		// Attendo un ciclo di clock per dare il tempo al modulo di processare i dati
		@(posedge clk);
		// @(posedge clk);
		
		// Resetto i segnali di validità per il prossimo test
		ptxt_valid <= 1'b0;
		key_valid  <= 1'b0;
		
		// Attendo che il ciphertext sia pronto prima di confrontarlo con il valore atteso
		wait (ctxt_ready);
		
		
		@(posedge clk);
		// Stampo i valori del plaintext, del ciphertext e del ciphertext atteso
		$display("%h %h %h %s", tmp_pt, ctxt, tmp_ct, (ctxt === tmp_ct) ? "OK" : "ERRORE CIPHERTEXT");
		rst_n <= 1'b0;

		@(posedge clk);
		rst_n <= 1'b1;
	end
	else begin
		$display("Fine simulazione");
		$stop;
	end
  end
  
endmodule

