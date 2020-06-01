create table book
  (ISBN varchar(20) not null primary key,
  title varchar(50) not null,
  page_num numeric(5,0),
  price numeric(8,2) not null,
  date_publish date,
  genre varchar(20)
  );

  create table author
  (author_name varchar(20) not null,
  ISBN varchar(20),
  primary key (author_name, ISBN),
  foreign key (ISBN) references book on delete cascade
  );
  
  create table publisher
  (publisher_name varchar(20),
  phone_number varchar(13),
  ISBN varchar(20),
  primary key (ISBN),
  foreign key (ISBN) references book on delete cascade
  );
  
  create table customer
  (customer_id varchar(4) not null,
  name varchar(20),
  address varchar (30),
  phone_number varchar(13),
  primary key (customer_id)
  );
  
  create table review
  (customer_id varchar(4),
  ISBN varchar(20),
  review varchar(50),
  rev_date date,
  rev_point int,
  primary key (ISBN, customer_id),
  foreign key (ISBN) references book on delete cascade,
  foreign key (customer_id) references customer on delete cascade
  );
  
  create table book_order
  (customer_id varchar(4),
  ISBN varchar(20),
  order_date date,
  primary key (customer_id, order_date),
  foreign key (ISBN) references book on delete cascade,
  foreign key (customer_id) references customer on delete cascade
  );
  
  insert into book values ('9780307277671', 'The Da Vinci Code', '481', '5000', to_date('28-Mar-2006','DD-MON_YYYY'), 'fiction');
  insert into book values ('9780062363602', 'Hidden Figures', '349', '13000', to_date('06-Dec-2016','DD-MON_YYYY'), 'science');
  insert into book values ('9760062301233', 'Elon Musk', '392', '30000', to_date('03-Mar-2005','DD-MON_YYYY'), 'biography');
  insert into book values ('9780071289597', 'Database System', '1349', '45000', to_date('12-Sep-2011','DD-MON_YYYY'), 'education');
  insert into book values ('9780013422467', 'Operating System', '828', '5000', to_date('23-Jul-2014','DD-MON_YYYY'), 'education');
  
  insert into author values('Abraham Silberschatz', '9780071289597');
  insert into author values('Abraham Silberschatz', '9780013422467');
  insert into author values('Ashlee Vance', '9760062301233');
  insert into author values('Margot Lee', '9780062363602');
  insert into author values('Greg Gagne', '9780013422467');
  insert into author values('Dan Brown', '9780307277671');

  insert into publisher values('Ecco', '010-9320-4632', '9760062301233');
  insert into publisher values('McGraw Hill', '010-6687-4345', '9780013422467');
  insert into publisher values('McGraw Hill', '010-6687-4345', '9780071289597');
  insert into publisher values('Anchor', '010-3344-1511', '9780307277671');
  insert into publisher values('William Morrow', '010-7732-5321', '9780062363602');
  
  insert into customer values (customer_id.nextval, 'Cecilia Chapman', '711-2880 Nulla St.', '010-2928-8383');
  insert into customer values (customer_id.nextval, 'Iris Watson', '8562 Fusce Rd.', '010-1110-5563');
  insert into customer values (customer_id.nextval, 'Celeste Slater', '606 Ullamcorper. Street', '010-9490-9923');
  insert into customer values (customer_id.nextval, 'Theodore Lowe', '867-859 Sit Rd.', '010-8908-7323');
  insert into customer values (customer_id.nextval, 'Calista Wise', '7292 Dictum Av.', '010-6864-3030');

  insert into review values ('1', '9760062301233', 'Inspiring', to_date('28-Dec-2016','DD-MON_YYYY'), '5');
  insert into review values ('2', '9780013422467', 'Professional', to_date('01-Feb-2017','DD-MON_YYYY'), '3');
  insert into review values ('3', '9780071289597', 'Much in detail', to_date('16-Nov-2016','DD-MON_YYYY'), '2');
  insert into review values ('4', '9780307277671', 'Astounding', to_date('02-May-2017','DD-MON_YYYY'), '4');
  insert into review values ('5', '9780062363602', 'Too fictional', to_date('23-Apr-2017','DD-MON_YYYY'), '1');

  insert into book_order values ('1', '9760062301233', to_date('20-Dec-2016','DD-MON_YYYY'));
  insert into book_order values ('2', '9780013422467', to_date('29-Jan-2017','DD-MON_YYYY'));
  insert into book_order values ('3', '9780071289597', to_date('10-Nov-2016','DD-MON_YYYY'));
  insert into book_order values ('4', '9780307277671', to_date('28-Mar-2017','DD-MON_YYYY'));
  insert into book_order values ('5', '9780062363602', to_date('17-Apr-2017','DD-MON_YYYY'));
  
SET SERVEROUTPUT ON
DECLARE
   x_isbn book.isbn%type;
   x_title book.title%type;
   x_pubdate book.date_publish%type;
   x_aname author.author_name%type;
   x_page book.page_num%type;
   x_price book.price%type;
   x_pname publisher.publisher_name%type;
   x_genre book.genre%type;
   x_review review.review%type;
   x_publishnum INTEGER;
   x_relgenre book.genre%type;
   x_cgenre book.genre%type;
   x_cname customer.name%type;
   x_revpoint review.rev_point%type;
   x_totpoint review.rev_point%type;
   
    cursor c1 is 
    select ISBN, title, date_publish, page_num, price, genre, publisher_name
    from book natural join publisher
    order by title;
      
    cursor c2 is 
    select author_name
    from book natural join author
    where x_title = title
    order by title, author_name;
    
    cursor c3 is 
    select review
    from book natural join review
    where x_title = title
    order by title;
    
    cursor c4 is
    select distinct author_name
    from author
    order by author_name;
    
    cursor c10 is 
    select publisher_name, count (author_name)
    from author natural join publisher
    where x_aname = author_name
    group by publisher_name;
    
    cursor c5 is 
    select genre
    from book
    order by title;
    
    cursor c6 is
    select customer.name, genre
    from customer natural join book_order natural join book
    order by customer.name;
    
    cursor c7 is
    select title
    from book
    where genre = x_relgenre;
    
    cursor c8 is 
    select customer.name
    from customer
    order by customer.name;
    
    cursor c9 is 
    select review, rev_point
    from customer natural join review
    where x_cname = customer.name;
    
BEGIN

--1
dbms_output.put_line('1)');
   OPEN c1;
   dbms_output.put_line(rpad('ISBN', 18)||rpad('Title', 20)||rpad('Date', 13)||rpad('Page', 6)||rpad('Price', 8)||rpad('Genre', 13)||rpad('Publisher', 18)||rpad('Review', 20)||rpad('Author',23));
   loop
      fetch c1 into x_isbn, x_title, x_pubdate, x_page, x_price, x_genre, x_pname;
      exit when c1%NOTFOUND;
      dbms_output.put (rpad(x_isbn, 18)||rpad(x_title, 20)||rpad(x_pubdate, 13)||rpad(x_page, 6)||rpad(x_price, 8)||rpad(x_genre, 13)||rpad(x_pname, 18));
      open c3;
      loop
        fetch c3 into x_review;
        exit when c3%NOTFOUND;
        dbms_output.put (rpad(x_review, 20));
      end loop;
      close c3;
      open c2;
      loop
        fetch c2 into x_aname;
        exit when c2%NOTFOUND;
        dbms_output.put (rpad(x_aname,23));
      end loop;
      close c2;
      dbms_output.put_line(' ');
   end loop;   
   CLOSE c1;
   dbms_output.put_line(' ');
   
--   2
dbms_output.put_line('2)');
  open c4;
  dbms_output.put_line(rpad('Author', 25)||rpad('Publisher', 20)||rpad('Number of times', 20));
  loop
    fetch c4 into x_aname;
    exit when c4%NOTFOUND;
    dbms_output.put(rpad(x_aname, 25));
    open c10;
    loop
      fetch c10 into x_pname, x_publishnum;
      exit when c10%NOTFOUND;
      dbms_output.put(rpad(x_pname, 20)||rpad(x_publishnum, 20));
    end loop;
    close c10;
    dbms_output.put_line(' ');
  end loop;
  close c4;
  dbms_output.put_line(' ');
   
 dbms_output.put_line('3)');
--   3
   open c5;
   dbms_output.put_line(rpad('Genre', 15)||rpad('Related genre', 15));
   loop
      
      fetch c5 into x_genre;
      exit when c5%NOTFOUND;
      case
      when (x_genre = 'education') then x_relgenre := 'biography';
      when (x_genre = 'biography') then x_relgenre := 'education';
      when (x_genre = 'science') then x_relgenre := 'fiction';
      when (x_genre = 'fiction') then x_relgenre := 'science';
      end case;
      dbms_output.put_line(rpad(x_genre, 15)||rpad(x_relgenre, 15));
   end loop;
   close c5;
   dbms_output.put_line(' ');
  
  dbms_output.put_line('4)');
--4
    open c6;
    dbms_output.put_line(rpad('Customer name', 20)||rpad('Order genre', 15)||rpad('Related genre', 15)||rpad('Recommended books', 20));
    loop
      x_relgenre := '';
      fetch c6 into x_cname, x_genre;
      exit when c6%NOTFOUND;
      dbms_output.put(rpad(x_cname, 20)||rpad(x_genre, 15));
      case
      when (x_genre = 'education') then x_relgenre := 'biography';
      when (x_genre = 'biography') then x_relgenre := 'education';
      when (x_genre = 'science') then x_relgenre := 'fiction';
      when (x_genre = 'fiction') then x_relgenre := 'science';
      else x_relgenre := 'science';
      end case;
      dbms_output.put(rpad(x_relgenre, 15));
      open c7;
      loop
      fetch c7 into x_title;
      exit when c7%NOTFOUND;
      dbms_output.put(rpad(x_title, 20));
      end loop;
      close c7;
      dbms_output.put_line(' ');
    end loop;
    close c6;
    dbms_output.put_line(' ');
    
    dbms_output.put_line('5) ');
--    5
  open c8;
  dbms_output.put_line(rpad('Customer name', 20)||rpad('Review', 20)||rpad('Total point', 15));
  loop
    fetch c8 into x_cname;
    exit when c8%NOTFOUND;
    dbms_output.put(rpad(x_cname, 20));
    x_totpoint := 0;
    open c9;
      loop
      fetch c9 into x_review, x_revpoint;
      exit when c9%NOTFOUND;
      x_totpoint := x_totpoint + x_revpoint;
      dbms_output.put(rpad(x_review, 20));
      end loop;
      close c9;
    dbms_output.put_line(rpad(x_totpoint, 20));
  end loop;
  close c8;
END;
