program PemesananTiketPesawat;
uses crt, sysutils;

const
  MAX_RUTE = 10;
  MAX_KURSI = 10;

type
  RutePenerbangan = record
    LokasiKeberangkatan: string;
    LokasiKetibaan: string;
    WaktuKeberangkatan: string; // Menyimpan waktu keberangkatan
    kursi: array[1..MAX_KURSI] of string; // Menyimpan nama penumpang di setiap kursi
  end;

var
  rute: array[1..MAX_RUTE] of RutePenerbangan;
  pilihanRute, pilihanKursi: integer;
  fileRute, fileTiket: text;
  namaPenumpang: string;
  pilihanMenu: char;

procedure SimpanDataRute;
var
  i, j: integer;
begin
  assign(fileRute, 'data_rute.txt');
  rewrite(fileRute);
  for i := 1 to MAX_RUTE do
  begin
    writeln(fileRute, rute[i].LokasiKeberangkatan, ' - ', rute[i].Lokasiketibaan, ' - ', rute[i].WaktuKeberangkatan);
    for j := 1 to MAX_KURSI do
      writeln(fileRute, rute[i].kursi[j]);
  end;
  close(fileRute);
end;

procedure AmbilDataRute;
var
  i, j: integer;
  temp: string;
begin
  if FileExists('data_rute.txt') then
  begin
    assign(fileRute, 'data_rute.txt');
    reset(fileRute);
    for i := 1 to MAX_RUTE do
    begin
      readln(fileRute, temp);
      rute[i].LokasiKeberangkatan := Copy(temp, 1, Pos(' - ', temp) - 1);
      Delete(temp, 1, Pos(' - ', temp) + 2);
      rute[i].Lokasiketibaan := Copy(temp, 1, Pos(' - ', temp) - 1);
      Delete(temp, 1, Pos(' - ', temp) + 2);
      rute[i].WaktuKeberangkatan := temp; // Membaca waktu keberangkatan

      for j := 1 to MAX_KURSI do
        readln(fileRute, rute[i].kursi[j]);
    end;
    close(fileRute);
  end
  else
  begin
    writeln('Data rute tidak ditemukan, menginisialisasi data baru.');

    rute[1].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[1].Lokasiketibaan := 'Jakarta(CGK)'; 
    rute[1].WaktuKeberangkatan := '06:00';
    rute[2].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[2].Lokasiketibaan := 'Surabaya(SUB)'; 
    rute[2].WaktuKeberangkatan := '06:30';
    rute[3].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[3].Lokasiketibaan := 'Denpasar(DPS)'; 
    rute[3].WaktuKeberangkatan := '07:00';
    rute[4].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[4].Lokasiketibaan := 'Yogyakarta(YIA)'; 
    rute[4].WaktuKeberangkatan := '07:30';
    rute[5].LokasiKeberangkatan := 'Palangkaraya(PKY)';
    rute[5].Lokasiketibaan := 'Palembang(PLM)';
    rute[5].WaktuKeberangkatan := '08:00';
    rute[6].LokasiKeberangkatan := 'Palangkaraya(PKY)';
    rute[6].Lokasiketibaan := 'Aceh(BTJ)';
    rute[6].WaktuKeberangkatan := '08:30';
    rute[7].LokasiKeberangkatan := 'Palangkaraya(PKY)';
    rute[7].Lokasiketibaan := 'Makassar(UPG)';
    rute[7].WaktuKeberangkatan := '09:00';
    rute[8].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[8].Lokasiketibaan := 'Manado(MDC'; 
    rute[8].WaktuKeberangkatan := '09:30';
    rute[9].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[9].Lokasiketibaan := 'Jayapura(JCC)'; 
    rute[9].WaktuKeberangkatan := '10:00';
    rute[10].LokasiKeberangkatan := 'Palangkaraya(PKY)'; 
    rute[10].Lokasiketibaan := 'Banjarmasin(BDJ)'; 
    rute[10].WaktuKeberangkatan := '10:30';
    
    for i := 1 to MAX_RUTE do
      for j := 1 to MAX_KURSI do
        rute[i].kursi[j] := ''; // Awalnya semua kursi tidak ada penumpang (kosong)
  end;
end;

procedure TampilkanRute;
var
  i: integer;
begin
  writeln('Daftar Rute Penerbangan:');
  for i := 1 to MAX_RUTE do
  begin
    writeln(i, '. ', rute[i].LokasiKeberangkatan, ' - ', rute[i].Lokasiketibaan, ' (Berangkat: ', rute[i].WaktuKeberangkatan, ')');
  end;
end;


function CariKursiKosong(indexRute, nomorKursi: integer): integer;
begin
  if nomorKursi > MAX_KURSI then
    CariKursiKosong := 0 // Tidak ada kursi kosong
  else if rute[indexRute].kursi[nomorKursi] = '' then
    CariKursiKosong := nomorKursi // Kursi kosong ditemukan
  else
    CariKursiKosong := CariKursiKosong(indexRute, nomorKursi + 1); // Rekursif mencari kursi kosong
end;

procedure TampilkanKursi(indexRute: integer);
var
  i: integer;
begin
  writeln('Kursi di Rute ', rute[indexRute].LokasiKeberangkatan, ' - ', rute[indexRute].Lokasiketibaan, ':');
  for i := 1 to MAX_KURSI do
  begin
    if rute[indexRute].kursi[i] = '' then
      writeln('Kursi ', i, ': Kosong')
    else
      writeln('Kursi ', i, ': Terisi oleh ', rute[indexRute].kursi[i]);
  end;
end;

procedure PesanTiket(indexRute: integer);
var
  nomorKursi: integer;
begin
  nomorKursi := CariKursiKosong(indexRute, 1);
  if nomorKursi = 0 then
    writeln('Maaf, semua kursi sudah terisi.')
  else
  begin
    writeln('Kursi tersedia di nomor: ', nomorKursi);
    write('Masukkan nama penumpang: ');
    readln(namaPenumpang);
    
    // Menandai kursi telah terpesan dengan menyimpan nama penumpang
    rute[indexRute].kursi[nomorKursi] := namaPenumpang;
    // Simpan data pemesanan ke dalam file
    assign(fileTiket, 'pemesanan_tiket.txt');
    if not FileExists('pemesanan_tiket.txt') then
      rewrite(fileTiket)
    else
      append(fileTiket);
    writeln(fileTiket, 'Nama: ', namaPenumpang, ', Rute: ', rute[indexRute].LokasiKeberangkatan, ' - ', rute[indexRute].Lokasiketibaan, ', Kursi: ', nomorKursi);
    close(fileTiket);
    writeln('Tiket berhasil dipesan!');
  end;
  SimpanDataRute();
end;

procedure BatalkanTiket(indexRute: integer);
var
  nomorKursi: integer;
  namaPembatal: string;
  tiketDitemukan: boolean;
begin
  tiketDitemukan := false;
  write('Masukkan nama penumpang yang ingin membatalkan: ');
  readln(namaPembatal);

  for nomorKursi := 1 to MAX_KURSI do
  begin
    if rute[indexRute].kursi[nomorKursi] = namaPembatal then
    begin
      rute[indexRute].kursi[nomorKursi] := '';
      writeln('Tiket untuk ', namaPembatal, ' berhasil dibatalkan di kursi nomor ', nomorKursi);
      tiketDitemukan := true;
      break;
    end;
  end;
  if not tiketDitemukan then
    writeln('Tidak dapat menemukan tiket atas nama ', namaPembatal, ' Pada Rute Ini.');
  
  SimpanDataRute();
end;

procedure Menu;
begin
  writeln('1. Tampilkan Rute Yang Ada');
  writeln('2. Pemesanan Tiket');
  writeln('3. Pembatalan Tiket');
  writeln('4. Tampilkan Kursi yang Tersedia');
  writeln('0. Keluar');
end;

begin
  clrscr;
  AmbilDataRute;
  repeat
    Menu();
    write('Pilih menu: ');
    readln(pilihanMenu);
    clrscr;

    case pilihanMenu of
      '1': TampilkanRute;
      '2':
      begin
        clrscr;
        TampilkanRute;
        write('Pilih rute penerbangan (1-', MAX_RUTE, '): ');
        readln(pilihanRute);
        if (pilihanRute >= 1) and (pilihanRute <= MAX_RUTE) then
          PesanTiket(pilihanRute)
        else
          writeln('Rute tidak valid.');
      end;
      '3':
      begin
        clrscr;
        TampilkanRute;
        write('Pilih rute penerbangan untuk pembatalan (1-', MAX_RUTE, '): ');
        readln(pilihanRute);
        if (pilihanRute >= 1) and (pilihanRute <= MAX_RUTE) then
          BatalkanTiket(pilihanRute)
        else
          writeln('Rute tidak valid.');
      end;
      '4':
      begin
        clrscr;
        TampilkanRute;
        write('Pilih rute penerbangan (1-', MAX_RUTE, '): ');
        readln(pilihanRute);
        if (pilihanRute >= 1) and (pilihanRute <= MAX_RUTE) then
          TampilkanKursi(pilihanRute)
        else
          writeln('Rute tidak valid.');
      end;
    end;
    writeln;
  until pilihanMenu = '0';
  writeln('Terima kasih telah menggunakan layanan kami.');
end.
