<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "locality".
 *
 * @property integer $locality_id
 * @property string $name
 *
 * @property Person[] $people
 * @property Property[] $properties
 */
class Locality extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'locality';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['name'], 'string', 'max' => 45],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'locality_id' => 'Locality ID',
            'name' => 'Name',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPeople()
    {
        return $this->hasMany(Person::className(), ['locality_id' => 'locality_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProperties()
    {
        return $this->hasMany(Property::className(), ['locality_id' => 'locality_id']);
    }
}
