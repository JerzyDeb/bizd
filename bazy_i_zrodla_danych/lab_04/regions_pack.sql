CREATE OR REPLACE PACKAGE REGIONS_PACK IS
    FUNCTION get_region_name(p_region_id REGIONS.REGION_ID%TYPE) RETURN VARCHAR2;
    PROCEDURE test_get_region_name(p_region_id IN REGIONS.REGION_ID%TYPE);
    PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_new_region_name IN REGIONS.REGION_NAME%TYPE);
    PROCEDURE create_region(p_new_region_id IN REGIONS.REGION_ID%TYPE, p_new_region_name IN REGIONS.REGION_NAME%TYPE);
    PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE);
END REGIONS_PACK;


CREATE OR REPLACE PACKAGE BODY REGIONS_PACK IS
    FUNCTION get_region_name(p_region_id REGIONS.REGION_ID%TYPE) RETURN VARCHAR2 IS
    name VARCHAR2(255);
    BEGIN
        SELECT REGION_NAME INTO name
        FROM REGIONS
        WHERE REGION_ID = p_region_id;
        RETURN name;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak regionu o takim ID. Kod błędu: ' || SQLCODE);
        RETURN NULL;
    END;

    -----------------------------------------------------------------------------

    PROCEDURE test_get_region_name(p_region_id IN REGIONS.REGION_ID%TYPE) IS
    region_name VARCHAR(255);
    BEGIN
        region_name := REGIONS_PACK.get_region_name(p_region_id);
        DBMS_OUTPUT.PUT_LINE('Nazwa regionu: ' || region_name);
    END;

    -----------------------------------------------------------------------------

    PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_new_region_name IN REGIONS.REGION_NAME%TYPE) IS
    BEGIN
        UPDATE REGIONS
        SET REGION_NAME = p_new_region_name
        WHERE REGION_ID = p_region_id;
        DBMS_OUTPUT.PUT_LINE('Zaktualizowano region');
    END;

    -----------------------------------------------------------------------------

    PROCEDURE create_region(p_new_region_id IN REGIONS.REGION_ID%TYPE, p_new_region_name IN REGIONS.REGION_NAME%TYPE) IS
    BEGIN
        INSERT INTO REGIONS (REGION_ID, REGION_NAME)
        VALUES (p_new_region_id, p_new_region_name);
        DBMS_OUTPUT.PUT_LINE('Dodano region');
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd podczas dodawania regionu. Kod błędu: ' || SQLCODE);
    END;


    -----------------------------------------------------------------------------

    PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE) IS
    BEGIN
        DELETE FROM REGIONS
        WHERE REGION_ID = p_region_id;
        DBMS_OUTPUT.PUT_LINE('Usunięto region');
    END;

END REGIONS_PACK;

BEGIN
    REGIONS_PACK.create_region(1111, 'TESTOWY REGION');
    REGIONS_PACK.update_region(1111, 'ZMIENIONA NAZWA');
    REGIONS_PACK.test_get_region_name(1111);
    REGIONS_PACK.delete_region(1111);
END;
