<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "person".
 *
 * @property integer $person_id
 * @property string $document_type
 * @property string $document_number
 * @property string $name
 * @property string $first_surname
 * @property string $second_surname
 * @property string $street
 * @property string $street_number
 * @property string $phone
 * @property string $mobile
 * @property integer $employee
 * @property string $job_adress
 * @property string $profession
 * @property string $civil_status
 * @property double $salary
 * @property string $commercial_references
 * @property string $bank_references
 * @property string $zip_code
 * @property string $bank
 * @property string $bank_number
 * @property string $bank_holder
 * @property string $bank_branch
 * @property integer $locality_id
 * @property string $type
 * @property integer $owner
 * @property string $cuit
 *
 * @property Locality $locality
 * @property PersonContract[] $personContracts
 * @property PersonProperty[] $personProperties
 * @property Property[] $properties
 */
class Person extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'person';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['document_type', 'document_number', 'name', 'first_surname'], 'required'],
            [['document_type', 'civil_status', 'type'], 'string'],
            [['employee', 'locality_id', 'owner'], 'integer'],
            [['salary'], 'number'],
            [['document_number'], 'string', 'max' => 12],
            [['name', 'first_surname', 'second_surname', 'street_number', 'phone', 'mobile', 'bank', 'bank_number', 'bank_branch', 'cuit'], 'string', 'max' => 45],
            [['street', 'job_adress', 'profession', 'commercial_references', 'bank_references', 'bank_holder'], 'string', 'max' => 255],
            [['zip_code'], 'string', 'max' => 15],
            [['locality_id'], 'exist', 'skipOnError' => true, 'targetClass' => Locality::className(), 'targetAttribute' => ['locality_id' => 'locality_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'person_id' => 'Person ID',
            'document_type' => 'Document Type',
            'document_number' => Yii::t('app', 'Document Number'),
            'name' => 'Name',
            'first_surname' => 'First Surname',
            'second_surname' => 'Second Surname',
            'street' => 'Street',
            'street_number' => 'Street Number',
            'phone' => 'Phone',
            'mobile' => 'Mobile',
            'employee' => 'Employee',
            'job_adress' => 'Job Adress',
            'profession' => 'Profession',
            'civil_status' => 'Civil Status',
            'salary' => 'Salary',
            'commercial_references' => 'Commercial References',
            'bank_references' => 'Bank References',
            'zip_code' => 'Zip Code',
            'bank' => 'Bank',
            'bank_number' => 'Bank Number',
            'bank_holder' => 'Bank Holder',
            'bank_branch' => 'Bank Branch',
            'locality_id' => 'Locality ID',
            'type' => 'Type',
            'owner' => 'Owner',
            'cuit' => 'Cuit',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLocality()
    {
        return $this->hasOne(Locality::className(), ['locality_id' => 'locality_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPersonContracts()
    {
        return $this->hasMany(PersonContract::className(), ['person_id' => 'person_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPersonProperties()
    {
        return $this->hasMany(PersonProperty::className(), ['person_id' => 'person_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProperties()
    {
        return $this->hasMany(Property::className(), ['property_id' => 'property_id'])->viaTable('person_property', ['person_id' => 'person_id']);
    }
}
