<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "config".
 *
 * @property integer $config_id
 * @property integer $IIBB_inscription
 * @property string $start_activities
 * @property string $seat_ring
 * @property string $establishment_number
 * @property string $company_adress
 * @property string $company_contact
 * @property integer $bd_version
 * @property string $payment_text
 * @property string $charge_text
 * @property string $cuit
 */
class Config extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'config';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['IIBB_inscription', 'bd_version'], 'integer'],
            [['start_activities'], 'safe'],
            [['payment_text', 'charge_text'], 'string'],
            [['seat_ring'], 'string', 'max' => 45],
            [['establishment_number'], 'string', 'max' => 15],
            [['company_adress', 'company_contact'], 'string', 'max' => 100],
            [['cuit'], 'string', 'max' => 13],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'config_id' => 'Config ID',
            'IIBB_inscription' => 'Iibb Inscription',
            'start_activities' => 'Start Activities',
            'seat_ring' => 'Seat Ring',
            'establishment_number' => 'Establishment Number',
            'company_adress' => 'Company Adress',
            'company_contact' => 'Company Contact',
            'bd_version' => 'Bd Version',
            'payment_text' => 'Payment Text',
            'charge_text' => 'Charge Text',
            'cuit' => 'Cuit',
        ];
    }
}
