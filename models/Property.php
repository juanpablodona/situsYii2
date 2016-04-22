<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "property".
 *
 * @property integer $property_id
 * @property string $street
 * @property string $street_number
 * @property string $zip_code
 * @property string $description
 * @property string $name
 * @property integer $locality_id
 * @property string $designation
 *
 * @property Contract[] $contracts
 * @property PersonProperty[] $personProperties
 * @property Person[] $people
 * @property Locality $locality
 */
class Property extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'property';
    }
    
    public $direction;

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['locality_id'], 'required'],
            [['locality_id'], 'integer'],
            [['street'], 'string', 'max' => 255],
            [['street_number', 'name'], 'string', 'max' => 45],
            [['zip_code'], 'string', 'max' => 15],
            [['description'], 'string', 'max' => 1000],
            [['designation'], 'string', 'max' => 90],
            [['locality_id'], 'exist', 'skipOnError' => true, 'targetClass' => Locality::className(), 'targetAttribute' => ['locality_id' => 'locality_id']],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'property_id' => 'Property ID',
            'street' => 'Street',
            'street_number' => 'Street Number',
            'zip_code' => 'Zip Code',
            'description' => 'Description',
            'name' => 'Name',
            'locality_id' => 'Locality ID',
            'designation' => 'Designation',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getContracts()
    {
        return $this->hasMany(Contract::className(), ['property_id' => 'property_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPersonProperties()
    {
        return $this->hasMany(PersonProperty::className(), ['property_id' => 'property_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPeople()
    {
        return $this->hasMany(Person::className(), ['person_id' => 'person_id'])->viaTable('person_property', ['property_id' => 'property_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLocality()
    {
        return $this->hasOne(Locality::className(), ['locality_id' => 'locality_id']);
    }
    
    public function setDirection(){
        $this->direction= $this->street . ' '. $this->street_number;
    }
}
