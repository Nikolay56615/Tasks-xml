
DROP TABLE IF EXISTS Sibling;
DROP TABLE IF EXISTS ParentChild;
DROP TABLE IF EXISTS Marriage;
DROP TABLE IF EXISTS Person;

DROP DOMAIN IF EXISTS parent_role_t;
DROP DOMAIN IF EXISTS gender_t;
DROP DOMAIN IF EXISTS person_name_t;
DROP DOMAIN IF EXISTS person_id_t;

CREATE DOMAIN person_id_t AS TEXT
    CHECK (VALUE ~ '^P[1-9][0-9]*$');

CREATE DOMAIN person_name_t AS TEXT
    CHECK (VALUE = btrim(VALUE) AND VALUE <> '');

CREATE DOMAIN gender_t AS TEXT
    CHECK (VALUE IN ('male', 'female'));

CREATE DOMAIN parent_role_t AS TEXT
    CHECK (VALUE IN ('mother', 'father'));

CREATE TABLE Person (
    id person_id_t PRIMARY KEY,
    first_name person_name_t NOT NULL,
    last_name person_name_t NOT NULL,
    gender gender_t NOT NULL
);

CREATE TABLE Marriage (
    person_id person_id_t NOT NULL,
    spouse_id person_id_t NOT NULL,
    CONSTRAINT pk_marriage PRIMARY KEY (person_id, spouse_id),
    CONSTRAINT uq_marriage_person UNIQUE (person_id),
    CONSTRAINT uq_marriage_spouse UNIQUE (spouse_id),
    CONSTRAINT fk_marriage_person
        FOREIGN KEY (person_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_marriage_spouse
        FOREIGN KEY (spouse_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_marriage_distinct CHECK (person_id <> spouse_id),
    CONSTRAINT chk_marriage_order CHECK (person_id < spouse_id)
);

CREATE TABLE ParentChild (
    child_id person_id_t NOT NULL,
    parent_id person_id_t NOT NULL,
    parent_role parent_role_t NOT NULL,
    CONSTRAINT pk_parent_child PRIMARY KEY (child_id, parent_role),
    CONSTRAINT uq_parent_child_pair UNIQUE (parent_id, child_id),
    CONSTRAINT fk_parent_child_child
        FOREIGN KEY (child_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_parent_child_parent
        FOREIGN KEY (parent_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_parent_child_diff CHECK (child_id <> parent_id)
);

CREATE TABLE Sibling (
    person_id person_id_t NOT NULL,
    sibling_id person_id_t NOT NULL,
    CONSTRAINT pk_sibling PRIMARY KEY (person_id, sibling_id),
    CONSTRAINT fk_sibling_person
        FOREIGN KEY (person_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_sibling_sibling
        FOREIGN KEY (sibling_id) REFERENCES Person(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_sibling_distinct CHECK (person_id <> sibling_id),
    CONSTRAINT chk_sibling_order CHECK (person_id < sibling_id)
);
